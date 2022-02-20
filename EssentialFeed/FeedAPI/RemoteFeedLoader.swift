//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by TCode on 14/2/22.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: LocalizedError{
        case connectivity
        case invalidData
    }

    public typealias FeedResult = Result<[FeedItem], Error>

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (FeedResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success((let data, let response)):
                do {
                    let items = try FeedItemMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
