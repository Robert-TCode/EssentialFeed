//
//  CoreDataFeedStoreIntegrationTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 25/3/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        expect(sut, toRetrieve: .success(.none))
    }

    func test_retrieve_deliversFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToLoad = try makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()

        insert((feed.local, timestamp), to: storeToInsert)

        expect(storeToLoad, toRetrieve: .success(CachedFeed(feed: feed.local, timestamp: timestamp)))
    }

    func test_insert_overridesFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToOverride = try makeSUT()
        let storeToLoad = try makeSUT()

        insert((uniqueImageFeed().local, Date()), to: storeToInsert)

        let latestFeed = uniqueImageFeed()
        let latestTimestamp = Date()
        insert((latestFeed.local, latestTimestamp), to: storeToOverride)

        expect(storeToLoad, toRetrieve: .success(CachedFeed(feed: latestFeed.local, timestamp: latestTimestamp)))
    }

    func test_delete_deletesFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToDelete = try makeSUT()
        let storeToLoad = try makeSUT()

        insert((uniqueImageFeed().local, Date()), to: storeToInsert)

        deleteCache(from: storeToDelete)

        expect(storeToLoad, toRetrieve: .success(.none))
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> FeedStore {
        let sut = try CoreDataFeedStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

    private func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
