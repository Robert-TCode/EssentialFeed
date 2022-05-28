//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by TCode on 28/5/22.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
