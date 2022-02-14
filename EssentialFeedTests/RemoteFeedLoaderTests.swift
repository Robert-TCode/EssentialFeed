//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 14/2/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {

}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()

        XCTAssertNil(client.requestedURL)
    }

}
