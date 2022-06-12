//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by TCode on 3/5/22.
//

import UIKit
import EssentialFeed

public protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
} 

public final class FeedRefreshViewController: NSObject, ResourceLoadingView {
    private(set) lazy var view = loadView()
    private let delegate: FeedRefreshViewControllerDelegate

    public init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }

    @objc func refresh() {
        delegate.didRequestFeedRefresh()
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
