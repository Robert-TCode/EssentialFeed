//
//  UIView+Container.swift
//  EssentialFeediOS
//
//  Created by TCode on 19/6/22.
//

import UIKit

extension UIView {
    public func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        container.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        self.pinToSuperview()

        return container
    }
}
