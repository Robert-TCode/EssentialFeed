//
//  FeedImage.swift
//  EssentialFeed
//
//  Created by TCode on 14/2/22.
//

import Foundation

public struct FeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let URL: URL

    public init(id: UUID, description: String?, location: String?, URL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.URL = URL
    }
}
