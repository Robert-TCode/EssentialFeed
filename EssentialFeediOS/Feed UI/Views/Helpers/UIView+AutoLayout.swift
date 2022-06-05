//
//  UIView+AutoLayout.swift
//  EssentialFeediOS
//
//  Created by TCode on 5/6/22.
//

import UIKit

extension UIView {
    func pinToSuperview(constant: CGFloat = 0) {
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant)
        ])
    }

    func pinHorizontally(to view: UIView) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func pinVertically(to view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
