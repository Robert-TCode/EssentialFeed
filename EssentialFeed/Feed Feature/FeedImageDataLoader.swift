//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by TCode on 3/5/22.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
