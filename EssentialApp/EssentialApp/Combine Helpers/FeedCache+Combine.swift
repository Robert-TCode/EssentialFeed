//
//  FeedCache+Combine.swift
//  EssentialApp
//
//  Created by TCode on 4/7/22.
//

import Combine
import EssentialFeed
import Foundation

extension Publisher {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> where Output == [FeedImage] {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }

    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> where Output == Paginated<FeedImage> {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

extension Publisher where Output == Data {
    func caching(to cache: FeedImageDataCache, using url: URL) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { data in
            cache.saveIgnoringResult(data, for: url)
        }).eraseToAnyPublisher()
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        try? save(data, for: url)
    }
}

private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        try? save(feed)
    }

    func saveIgnoringResult(_ page: Paginated<FeedImage>) {
        saveIgnoringResult(page.items)
    }
}
