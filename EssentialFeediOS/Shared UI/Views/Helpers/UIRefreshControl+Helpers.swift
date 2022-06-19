//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by TCode on 21/5/22.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
