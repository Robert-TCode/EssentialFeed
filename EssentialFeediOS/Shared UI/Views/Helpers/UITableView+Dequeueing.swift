//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by TCode on 12/5/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
