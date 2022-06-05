//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by TCode on 5/6/22.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
