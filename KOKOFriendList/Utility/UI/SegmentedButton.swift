//
//  SegmentedButton.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/6.
//

import UIKit

class SegmentedButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 0
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

