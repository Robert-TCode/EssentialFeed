//
//  ResourceLoadingView.swift
//  EssentialFeed
//
//  Created by TCode on 12/6/22.
//

import Foundation

public protocol ResourceLoadingView: AnyObject {
    func display(_ viewModel: ResourceLoadingViewModel)
}
