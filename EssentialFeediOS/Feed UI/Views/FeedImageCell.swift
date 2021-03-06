//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by TCode on 27/4/22.
//

import UIKit

public final class FeedImageCell: UITableViewCell {

    var onRetry: (() -> Void)?

    @objc private func retryButtonTapped() {
        onRetry?()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = "feed-image-cell"

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        feedImageView.image = nil
        locationLabel.text?.removeAll()
        descriptionLabel.text?.removeAll()
    }

    // MARK: View SetUp

    private func setupView() {
        // Location
        locationContainer.addSubview(locationImageView)
        locationContainer.addSubview(locationLabel)

        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: locationContainer.topAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: locationContainer.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor)
        ])

        // Feed Image
        feedImageContainer.addSubview(feedImageView)
        feedImageContainer.addSubview(feedImageRetryButton)
        feedImageView.pinToSuperview()
        feedImageRetryButton.pinToSuperview()

        // Cell
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.addArrangedSubview(locationContainer)
        stack.addArrangedSubview(feedImageContainer)
        stack.addArrangedSubview(descriptionLabel)

        locationContainer.pinHorizontally(to: stack)
        feedImageContainer.pinHorizontally(to: stack)
        NSLayoutConstraint.activate([
            feedImageContainer.heightAnchor.constraint(equalTo: feedImageContainer.widthAnchor)
        ])

        addSubview(stack)
        stack.pinToSuperview(constant: 16)

    }

    // MARK: Subviews

    private(set) public lazy var locationContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) public lazy var feedImageContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pin", in: Bundle(for: Self.self), compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])

        return imageView
    }()

    private(set) public lazy var feedImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.accessibilityIdentifier = "feed-image-view"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("???", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 60)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    private(set) public lazy var locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private(set) public lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
}

extension UIImage {
    static func placeholder() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.gray.withAlphaComponent(0.2).cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
