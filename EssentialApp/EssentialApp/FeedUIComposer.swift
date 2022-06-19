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
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

    private init() {}

    public static func feedComposedWith (
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: { feedLoader().dispatchOnMainQueue() })
        let refreshController = ListRefreshViewController(delegate: presentationAdapter)
        let feedController = ListViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )

        return feedController
    }
}

private extension ListViewController {
    static func makeWith(refreshController: ListRefreshViewController, title: String) -> ListViewController {
        let feedController = ListViewController(refreshController: refreshController)
        feedController.title = FeedPresenter.title
        return feedController
    }
}
