//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by TCode on 21/5/22.
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: Self.self),
            comment: "Title for the feed view "
        )
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
