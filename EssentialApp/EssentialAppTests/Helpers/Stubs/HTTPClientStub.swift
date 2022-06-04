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

    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }

    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }

    // MARK: - Helpers

    static func successfulResponse(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private static func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()

        default:
            return makeFeedData()
        }
    }

    static func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }

    private static func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"]
        ]])
    }
}
