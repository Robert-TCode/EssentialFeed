//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by TCode on 24/5/22.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
