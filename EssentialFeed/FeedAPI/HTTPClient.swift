//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by TCode on 20/2/22.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
