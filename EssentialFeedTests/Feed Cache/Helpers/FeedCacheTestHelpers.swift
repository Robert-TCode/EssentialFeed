//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by TCode on 12/3/22.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", URL: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, URL: $0.URL) }

    return (items, localItems)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMacAgeInDays)
    }

    private var feedCacheMacAgeInDays: Int {
        return 7
    }
}
