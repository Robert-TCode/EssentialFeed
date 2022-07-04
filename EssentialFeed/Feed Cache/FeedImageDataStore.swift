//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by TCode on 24/5/22.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
