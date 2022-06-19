//
//  ListRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by TCode on 3/5/22.
//

import UIKit
import EssentialFeed

public protocol ListRefreshViewControllerDelegate {
    func didRequestRefresh()
} 

public final class ListRefreshViewController: NSObject, ResourceLoadingView {
    private(set) lazy var view = loadView()
    private let delegate: ListRefreshViewControllerDelegate

    public init(delegate: ListRefreshViewControllerDelegate) {
        self.delegate = delegate
    }

    @objc func refresh() {
        delegate.didRequestRefresh()
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
