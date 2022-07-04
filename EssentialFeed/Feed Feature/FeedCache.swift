//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by TCode on 28/5/22.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
