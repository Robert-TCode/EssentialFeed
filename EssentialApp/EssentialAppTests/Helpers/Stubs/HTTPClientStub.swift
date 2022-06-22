//
//  HTTPClientStub.swift
//  EssentialAppTests
//
//  Created by TCode on 4/6/22.
//

import EssentialFeed
import UIKit

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }

    typealias ResultForURLRequest = (URL) -> HTTPClient.Result

    private let stub: ResultForURLRequest

    init(stub: @escaping ResultForURLRequest) {
        self.stub = stub
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }

    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}

extension HTTPClientStub {
    static func successfulResponse(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private static func makeData(for url: URL) -> Data {
        switch url.path {
        case "/image-1", "/image-2":
            return makeImageData()
        case "/essential-feed/v1/feed":
            return makeFeedData()
        case "/essential-feed/v1/image/2AB2AE66-A4B7-4A16-B374-51BBAC8DB086/comments":
            return makeCommentsData()
        default:
            return Data()
        }
    }

    static func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }

    private static func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "2AB2AE66-A4B7-4A16-B374-51BBAC8DB086", "image": "http://feed.com/image-1"],
            ["id": "A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A", "image": "http://feed.com/image-2"]
        ]])
    }

    private static func makeCommentsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            [
                "id": UUID().uuidString,
                "message": makeCommentsMessage() ,
                "created_at": "2022-06-22T10:20:00+0000",
                "author": [
                    "username": "a username"
                ]
            ]
        ]])
    }

    static func makeCommentsMessage() -> String {
        "a message"
    }
}
