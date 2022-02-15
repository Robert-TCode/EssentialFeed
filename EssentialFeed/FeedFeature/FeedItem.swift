//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by TCode on 14/2/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let iamgeURL: URL
}
