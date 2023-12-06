//
//  UITableView+Extension.swift
//  KOKOFriendList
//
//  Created by Person Zhang on 2023/12/5.
//

import UIKit

extension UITableView {
    func registerClass<T: UITableViewCell>(cellClass `class`: T.Type) where T: Reusable {
        register(`class`, forCellReuseIdentifier: `class`.reuseIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(cellClass `class`: T.Type) where T: NibProvidable & Reusable {
        register(`class`.nib, forCellReuseIdentifier: `class`.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type) -> T? where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type, forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}

