//
//  FriendListTableViewCell.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import UIKit


class FriendListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starIV: UIImageView!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var othersBtn: UIButton!
    
    var selectIndexPath: IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureUI() {
        transferBtn.setView(withCornerRadius: CornerRadiusSize.small, borderColor: .cellPink, borderWidth: 1)
//        othersBtn.setTitleColor(.cellGray, for: .normal)
    }
    
    func bindWithList(cellData: FriendListItem, indexPath: IndexPath) {
        selectIndexPath = indexPath
        nameLabel.text = cellData.name
        starIV.isHidden = Int(cellData.isTop ?? "0") ?? 0 > 0 ? false : true
        
        var othersTitle = ""
        var othersImage = UIImage(named: ImageName.icFriendsMore)
        var othersBWidth = 0
        if (cellData.status == 0) {
            othersTitle = Constant.inviting
            othersImage = nil
            othersBWidth = 1
        }
        othersBtn.setTitle(othersTitle, for: .normal)
        othersBtn.setImage(othersImage, for: .normal)
//        othersBtn.setBackgroundImage(othersImage, for: .normal)
        othersBtn.setView(withCornerRadius: CornerRadiusSize.small, borderColor: .cellGray, borderWidth: CGFloat(othersBWidth))
        
        
    }
    @IBAction func clickTransferBtn(_ sender: Any) {
        debugPrint("clickTransferBtn")
    }
    
    @IBAction func clickOthersBtn(_ sender: Any) {
        debugPrint("clickOthersBtn")
    }
}

