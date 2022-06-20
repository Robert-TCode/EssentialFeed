//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by TCode on 20/6/22.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

public final class CommentsUIComposer {
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

    private init() {}

    public static func commentsComposedWith (
        commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: { commentsLoader().dispatchOnMainQueue() })
        let refreshController = ListRefreshViewController()
        refreshController.onRefresh = presentationAdapter.loadResource
        let feedController = ListViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher()}
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
