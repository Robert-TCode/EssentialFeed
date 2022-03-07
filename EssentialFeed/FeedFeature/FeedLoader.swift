//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by TCode on 14/2/22.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
