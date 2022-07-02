//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by TCode on 4/5/22.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

public final class FeedUIComposer {
    private typealias  FeedPresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>

    private init() {}

    public static func feedComposedWith (
        feedLoader: @escaping () -> AnyPublisher<Paginated<FeedImage>, Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping ((FeedImage) -> Void) = { _ in }
    ) -> ListViewController { 
        let presentationAdapter = FeedPresentationAdapter(loader: { feedLoader().dispatchOnMainQueue() })
        let refreshController = ListRefreshViewController()
        refreshController.onRefresh = presentationAdapter.loadResource
        let feedController = ListViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(feedController)
        )

        return feedController
    }
}

private extension ListViewController {
    static func makeWith(refreshController: ListRefreshViewController, title: String) -> ListViewController {
        let feedController = ListViewController(refreshController: refreshController)
        feedController.title = title
        return feedController
    }
}
