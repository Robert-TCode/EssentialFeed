//
//  ListRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by TCode on 3/5/22.
//

import UIKit
import EssentialFeed

public final class ListRefreshViewController: NSObject, ResourceLoadingView {
    private(set) lazy var view = loadView()
    public var onRefresh: (() -> Void)?

    @objc func refresh() {
        onRefresh?()
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        view.update(isRefreshing: viewModel.isLoading)
    }

    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
