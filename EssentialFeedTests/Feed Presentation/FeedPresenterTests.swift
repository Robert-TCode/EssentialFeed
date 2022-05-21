//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 21/5/22.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {}
}

class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()

        _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expect no view messages")
    }

    // MARK: Helpers

    private class ViewSpy {
        let messages = [Any]()
    }
}
