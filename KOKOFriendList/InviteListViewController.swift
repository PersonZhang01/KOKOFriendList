//
//  InviteListViewController.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/6.
//

import UIKit
import Combine

protocol InviteListVCDelegate: AnyObject {

}

class InviteListViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!

    // pipeline(管道)的開頭
    private let idle = PassthroughSubject<Void, Never>()
    private let getUserInfo = PassthroughSubject<Void, Never>()
    private let getFriendList = PassthroughSubject<Int, Never>()
    
    // 控制項、其他常數及變數
    weak var delegate: InviteListVCDelegate?
    weak var viewModel: FriendListViewModel?
    private lazy var dataSource = createDataSource()
    let refreshControl = UIRefreshControl()
    var testNumber = 0
    
    //MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo.send()
        getFriendList.send(testNumber)
    }
    
    func configureUI() {
        configureTableView()
    }
    

    //MARK: TableView
    func configureTableView() {
        // 註冊Cell
        tableView.registerNib(cellClass: InviteListTableViewCell.self)

        // 設置delegate 跟 source
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 80.0
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
            let cell = tableView.dequeueReusableCell(withClass: InviteListTableViewCell.self, forIndexPath: indexPath)
            cell.bindWithList(cellData: cellData, indexPath: indexPath)
            return cell
        }
    }
    
    func update(withList list: [FriendListItem], animate: Bool = true) {
        DispatchQueue.main.async { [unowned self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, FriendListItem>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(list, toSection: .list)
            dataSource.apply(snapshot, animatingDifferences: animate)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

}

// MARK: UITableViewDelegate
extension InviteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
