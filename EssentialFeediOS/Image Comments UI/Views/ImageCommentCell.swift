//
//  ImageCommentCell.swift
//  EssentialFeediOS
//
//  Created by TCode on 19/6/22.
//

import UIKit

public final class ImageCommentCell: UITableViewCell {

    var onRetry: (() -> Void)?

    @objc private func retryButtonTapped() {
        onRetry?()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = "image-comment-cell"

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View SetUp

    private func setupView() {
        let horizontalStack = UIStackView(frame: .zero)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.addArrangedSubview(usernameLabel)
        horizontalStack.addArrangedSubview(dateLabel)

        let verticalStack = UIStackView(frame: .zero)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(messageLabel)

        addSubview(verticalStack)
        verticalStack.pinToSuperview(constant: 16)
    }

    // MARK: Subviews

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("↻", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 60)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    private(set) public lazy var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private(set) public lazy var usernameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        return label
    }()

    private(set) public lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()
}
