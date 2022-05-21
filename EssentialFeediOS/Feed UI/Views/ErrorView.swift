//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by TCode on 21/5/22.
//

import UIKit

public final class ErrorView: UIView {
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
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
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.backgroundColor = .systemOrange
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
}
