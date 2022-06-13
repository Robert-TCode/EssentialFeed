//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by TCode on 23/5/22.
//

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
