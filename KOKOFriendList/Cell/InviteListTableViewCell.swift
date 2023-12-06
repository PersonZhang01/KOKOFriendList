//
//  InviteListTableViewCell.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/6.
//

import UIKit


class InviteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starIV: UIImageView!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cardView: UIStackView!
    
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
        cardView.setView(withCornerRadius: CornerRadiusSize.small, borderColor: .cellGray, borderWidth: 1)
        cardView.setShadow()
        hintLabel.text = Constant.invite
    }
    
    func bindWithList(cellData: FriendListItem, indexPath: IndexPath) {
        selectIndexPath = indexPath
        nameLabel.text = cellData.name
        
    }
    @IBAction func clickAgreeBtn(_ sender: Any) {
        debugPrint("clickAgreeBtn")
    }
    
    @IBAction func clickDeleteBtn(_ sender: Any) {
        debugPrint("clickDeleteBtn")
    }
    
}

