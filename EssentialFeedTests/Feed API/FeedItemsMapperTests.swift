//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 14/2/22.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let jsonData = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(jsonData, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSONData = Data("invalid-data".utf8)

        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSONData, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSONData = makeItemsJSON([])

        let result = try FeedItemsMapper.map(emptyListJSONData, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversFeedItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(),
                             imageURL: URL(string: "https://a-url.com")!)
        let item2 = makeItem(id: UUID(),
                             description: "a description",
                             location: "a location",
                             imageURL: URL(string: "https://another-url.com")!)
        let jsonData = makeItemsJSON([item1.json, item2.json])

        let result = try FeedItemsMapper.map(jsonData, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: - Helpers

    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        let model = FeedImage(id: id, description: description, location: location, URL: imageURL)
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        return (model, json)
    }
}
