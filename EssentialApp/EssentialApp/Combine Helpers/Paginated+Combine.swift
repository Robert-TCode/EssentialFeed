//
//  Paginated+Combine.swift
//  EssentialApp
//
//  Created by TCode on 4/7/22.
//

import Combine
import EssentialFeed
import Foundation

public extension Paginated {

    init(items: [Item], loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.init(items: items, loadMore: loadMorePublisher.map { publisher in
            return { completion in
                // Using .subscribe(Subscribers.Sink) instead of .sink because this way
                // we don't have to manage the cancellable.
                publisher().subscribe(Subscribers.Sink(receiveCompletion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    }
                }, receiveValue: { result in
                    completion(.success(result))
                }))
            }
        })
    }

    var loadMorePublisher: (() -> AnyPublisher<Self, Error>)? {
        guard let loadMore = loadMore else { return nil }

        return {
            Deferred {
                Future(loadMore)
            }
            .eraseToAnyPublisher()
        }
    }
}
