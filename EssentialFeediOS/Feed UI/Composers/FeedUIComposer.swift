//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by TCode on 4/5/22.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
        let feedController = FeedViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title )

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            ),
            loadingView: WeakRefVirtualProxy(refreshController)
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
