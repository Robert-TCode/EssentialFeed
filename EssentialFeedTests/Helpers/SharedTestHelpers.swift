//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by TCode on 12/3/22.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any domain", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
