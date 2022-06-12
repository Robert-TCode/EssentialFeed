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
    private init() {}

    public static func feedComposedWith (
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher
    ) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: { feedLoader().dispatchOnMainQueue() })
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title )

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

private extension FeedViewController {
    static func makeWith(refreshController: FeedRefreshViewController, title: String) -> FeedViewController {
        let feedController = FeedViewController(refreshController: refreshController)
        feedController.title = FeedPresenter.title
        return feedController
    }
}
