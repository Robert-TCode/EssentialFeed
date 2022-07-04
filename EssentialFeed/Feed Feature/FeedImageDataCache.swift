//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by TCode on 28/5/22.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
