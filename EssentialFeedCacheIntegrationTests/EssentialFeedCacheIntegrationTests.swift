//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by TCode on 24/3/22.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        expect(sut, toRetrieve: .empty)
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> FeedStore {
        let sut = try CoreDataFeedStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
