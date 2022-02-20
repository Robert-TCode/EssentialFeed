//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by TCode on 14/2/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: LocalizedError {
        case connectivity
        case invalidData
    }

    public typealias FeedResult = LoadFeedResult

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (FeedResult) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success((let data, let response)):
                completion(FeedItemMapper.map(data, from: response))

            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
