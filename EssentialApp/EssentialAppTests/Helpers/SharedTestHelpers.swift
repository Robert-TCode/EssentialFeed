//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by TCode on 28/5/22.
//

import EssentialFeed

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "a description", location: "a location", URL: anyURL())]
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}

class DummyView: ResourceView {
    typealias ResourceViewModel = Any

    func display(_ viewModel: Any) {}
}
