//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by TCode on 4/6/22.
//

import EssentialFeediOS
import XCTest
@testable import EssentialApp

class FeedAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(HTTPClientStub.successfulResponse), store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), HTTPClientStub.makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), HTTPClientStub.makeImageData1())
        XCTAssertTrue(feed.canLoadMoreFeed)

        feed.simulateLoadMoreFeedAction()

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), HTTPClientStub.makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), HTTPClientStub.makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), HTTPClientStub.makeImageData2())
        XCTAssertTrue(feed.canLoadMoreFeed)

        feed.simulateLoadMoreFeedAction()

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), HTTPClientStub.makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), HTTPClientStub.makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), HTTPClientStub.makeImageData2())
        XCTAssertFalse(feed.canLoadMoreFeed)
    }

    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty

        let onlineFeed = launch(httpClient: .online(HTTPClientStub.successfulResponse), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedImageViewVisible(at: 2)

        let offlineFeed = launch(httpClient: .offline, store: sharedStore)

        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), HTTPClientStub.makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), HTTPClientStub.makeImageData1())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 2), HTTPClientStub.makeImageData2())
    }

    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)

        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }

    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }

    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache

        enterBackground(with: store)

        XCTAssertNotNil(store.feedCache, "Expected to keep non-expired cache")
    }

    func test_onImageSelection_displaysComments() {
        let comments = showCommentsForFirstImage()

        XCTAssertEqual(comments.numberOfRenderedComments(), 1)
        XCTAssertEqual(comments.commentMessage(at: 0), HTTPClientStub.makeCommentsMessage())
    }

    // MARK: - Helpers

    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFeedStore = .empty
    ) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store, scheduler: .immediateOnMainQueue)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }

    private func showCommentsForFirstImage() -> ListViewController {
        let feed = launch(httpClient: .online(HTTPClientStub.successfulResponse), store: .empty)

        feed.simulateTapOnFeedImage(at: 0)
        RunLoop.current.run(until: Date())

        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store, scheduler: .immediateOnMainQueue)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
}
