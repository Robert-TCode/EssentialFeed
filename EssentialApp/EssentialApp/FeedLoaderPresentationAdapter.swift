//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by TCode on 18/5/22.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    private var cancellable: Cancellable?

    var presenter: FeedPresenter?

    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        cancellable = feedLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case let .failure(error):
                        self?.presenter?.didFinishLoadingFeed(with: error)
                    }
                }, receiveValue: { [weak self] feed in
                    self?.presenter?.didFinishLoadingFeed(with: feed)
                })

    }
}
