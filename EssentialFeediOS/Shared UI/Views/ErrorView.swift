//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by TCode on 21/5/22.
//

import UIKit

public final class ErrorView: UIButton {
    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }

    public var onHide: (() -> Void)?

    private var isVisible: Bool {
        return alpha > 0
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        hideMessage()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View SetUp

    private func setupView() {
        configuration = Configuration.plain()
        backgroundColor = .errorBackgroundColor
        setTitleColor(.white, for: .normal)

        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)

        titleLabel?.font = .systemFont(ofSize: 15)
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = false
    }

    // MARK: Helpers

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        setTitle(message, for: .normal)
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }

    private func hideMessage() {
        setTitle(nil, for: .normal)
        alpha = 0
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 0, bottom: -9, trailing: 0)
        onHide?()
    }
}

extension UIColor {

    static var errorBackgroundColor: UIColor {
        UIColor(displayP3Red: 0.99, green: 0.42, blue: 0.41, alpha: 1)
    }
}
