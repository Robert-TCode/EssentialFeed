//
//  LocalFeedLoader+Combine.swift
//  EssentialApp
//
//  Created by TCode on 4/7/22.
//

import Combine
import EssentialFeed
import Foundation

public extension FeedImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>

    func loadImageDataPublisher(from url: URL) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.loadImageData(from: url)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension LocalFeedLoader {
    typealias Publisher = AnyPublisher<[FeedImage], Error>

    func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                completion(Result{ try self.load() })
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}
