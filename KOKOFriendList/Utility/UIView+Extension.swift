//
//  UIView+Extension.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import Foundation
import UIKit

extension UIView {
    
    func setFrame(rect: CGRect? = nil) {
        guard let rect = rect else {
            self.frame = UIApplication.shared.nowkeyWindow?.frame ?? CGRect()
            return
        }
        self.frame = rect
    }
    
    func changeAlpha(_ withAlpha: CGFloat, duration: TimeInterval,delay: TimeInterval,completion:((UIViewAnimatingPosition)-> Void)?) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: delay, animations: {
            self.alpha = withAlpha
        },completion: completion)
    }
    
    func setCircleCornerRadius() {
        self.layer.cornerRadius = self.frame.height*0.5
        self.clipsToBounds = true
    }
    
    func setView(withCornerRadius cornerRadius: CGFloat = 0,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat = 0,
                 maskedCorners: CACornerMask = [.layerMaxXMaxYCorner,
                                                .layerMaxXMinYCorner,
                                                .layerMinXMaxYCorner,
                                                .layerMinXMinYCorner]) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.maskedCorners = maskedCorners
        self.clipsToBounds = true
    }
    
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.5
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowOpacity = 0.2
        
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIView: NibProvidable {
    
}

