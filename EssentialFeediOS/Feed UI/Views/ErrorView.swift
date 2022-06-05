//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by TCode on 21/5/22.
//

import UIKit

public final class ErrorView: UIView {
    public var message: String? {
        get { return isVisible ? label.text : nil }
        set { setMessageAnimated(newValue) }
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        alpha = 0
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View SetUp

    private func setupView() {
        addSubview(label)
        label.pinToSuperview()
    }

    // MARK: Subviews

    private(set) public lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.backgroundColor = .systemOrange
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true

        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.hideMessageAnimated))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)

        return label
    }()

    // MARK: Helpers

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        label.text = message

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.label.text = nil }
            })
    }
}
