//
//  FriendListViewController.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import UIKit
import Combine

class FriendListViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var atmBtn: UIButton!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var kokoIdLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteViewHeight: NSLayoutConstraint!
    
    // pipeline(管道)的開頭
    private let idle = PassthroughSubject<Void, Never>()
    private let getUserInfo = PassthroughSubject<Void, Never>()
    private let getFriendList = PassthroughSubject<Int, Never>()
    
    // ViewModel
    public let viewModel: FriendListViewModel = FriendListViewModel(
        friendListUseCase: FriendListUseCase(),
        userInfoUseCase: UserInfoUseCase())
    
    // 取消pipeline(管道)的引用
    private var anycancellableSet: Set<AnyCancellable> = []
    
    // 控制項、其他常數及變數
    private var intiteListVC: InviteListViewController!
    private lazy var dataSource = createDataSource()
    let refreshControl = UIRefreshControl()
    var testNumber = 0
    
    //MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        bind(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo.send()
        getFriendList.send(testNumber)
    }
    
    func configureUI() {
        configSearchView()
        configureTableView()
        updateInfoView()
        updateInviteView()
        updateEmptyView()
    }
    
    func updateInfoView() {
        self.nameLbl.text = self.viewModel.userInfo.name ?? ""
        self.kokoIdLbl.text = "\(Constant.kokoId) : \(self.viewModel.userInfo.kokoid ?? "")"
    }
    
    func updateInviteView() {
        inviteViewHeight.constant = CGFloat(viewModel.inviteList.count * 80)
    }
    
    func updateEmptyView() {
        self.emptyView.isHidden = self.viewModel.friendAllList.isEmpty ? false : true
        self.tableView.isHidden = !self.emptyView.isHidden
        self.searchView.isHidden = !self.emptyView.isHidden
    }
    
    func updateSearchView() {
        self.infoView.isHidden = true
        inviteViewHeight.constant = 0
    }
    
    func configSearchView() {
        searchView.textField.placeholder = Constant.searchHint
        searchView.textField.delegate = self
        searchView.delegate = self
    }
    
    //MARK: UI change
    private func bind(to viewModel: FriendListViewModel) {
        anycancellableSet.forEach{ $0.cancel() }
        anycancellableSet.removeAll()
        let input = FriendListViewModelInput(
            idle: idle,
            userInfo: getUserInfo,
            friendList: getFriendList)
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            render(state)
        }).store(in: &anycancellableSet)
    }
    
    // 輸出的狀態
    private func render(_ state: FriendListViewModelState) {
        switch state {
        case .idle: return
        case .userInfoSuccess(let resp):
            userInfoSuccess(resp: resp)
        case .userInfoError(let resp):
            userInfoError(error: resp)
        case .friendListSuccess(let resp):
            friendListSuccess(resp: resp)
        case .friendListError(let resp):
            friendListError(error: resp)
        }
        idle.send()
    }
    
    func userInfoSuccess(resp: UserInfoRespModel?) {
        debugPrint("FriendListViewModelState:userInfoSuccess.")
        resp?.getJsonString()
        viewModel.updateUerInfo(withInfo: resp)
        update(withInfo: viewModel.userInfo, animate: false)
    }
    
    func userInfoError(error: NetworkError?) {
        debugPrint("FriendListViewModelState:userInfoError.\(error.debugDescription)")
    }
    
    func friendListSuccess(resp: FriendListRespModel?) {
        debugPrint("FriendListViewModelState:friendListSuccess.")
        resp?.getJsonString()
        viewModel.updateFriendList(withList: resp)
        update(withList: viewModel.friendList, animate: false)
    }
    
    func friendListError(error: NetworkError?) {
        debugPrint("FriendListViewModelState:friendListError.\(error.debugDescription)")
    }

    //MARK: TableView
    func configureTableView() {
        // 註冊Cell
        tableView.registerNib(cellClass: FriendListTableViewCell.self)

        // 設置delegate 跟 source
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 66.0
    }
    
    @objc
    func reloadTableView() {
        getFriendList.send(testNumber)
    }
    
    private enum Section: CaseIterable {
        case list
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, FriendListItem> {
        return UITableViewDiffableDataSource(tableView: tableView) {[unowned self] tableView, indexPath, cellData in
            let cell = tableView.dequeueReusableCell(withClass: FriendListTableViewCell.self, forIndexPath: indexPath)
            cell.bindWithList(cellData: cellData, indexPath: indexPath)
            return cell
        }
    }
    
    func update(withInfo info: UserInfoItem, animate: Bool = true) {
        DispatchQueue.main.async { [unowned self] in
            updateInfoView()
        }
    }
    
    func update(withList list: [FriendListItem], animate: Bool = true) {
        DispatchQueue.main.async { [unowned self] in
            updateEmptyView()
            updateInviteView()
            self.infoView.isHidden = false
            var snapshot = NSDiffableDataSourceSnapshot<Section, FriendListItem>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(list, toSection: .list)
            dataSource.apply(snapshot, animatingDifferences: animate)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            self.intiteListVC.update(withList: viewModel.inviteList)
        }
    }
    
    //MARK: UI event
    @IBAction func clickScanBtn(_ sender: Any) {
        testNumber = (testNumber + 1) % 4
        testLbl.text = ApiURL.friendList[testNumber]
        getFriendList.send(testNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.view.translatesAutoresizingMaskIntoConstraints = false;
        switch segue.destination {
        case is InviteListViewController:
            intiteListVC = segue.destination as? InviteListViewController
            intiteListVC.delegate = self
            intiteListVC.viewModel = viewModel
        default: break
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

// MARK: UITableViewDelegate
extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

//MARK: SearchViewDelegate
extension FriendListViewController: SearchViewDelegate {
    func searchButtonPressed() {
        self.viewModel.searchFriend()
        update(withList: self.viewModel.friendList, animate: false)
    }
}

// MARK: UITextFieldDelegate
extension FriendListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let range = Range(range,in: text) else { return true }
        viewModel.searchWord = text.replacingCharacters(in: range, with: string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        debugPrint("textField:\(textField.debugDescription)")
        self.updateSearchView()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        debugPrint("textField:\(String(describing: textField.text))")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

//MARK: AlbumParentPhotoVCDelegate
extension FriendListViewController: InviteListVCDelegate {
    
}




