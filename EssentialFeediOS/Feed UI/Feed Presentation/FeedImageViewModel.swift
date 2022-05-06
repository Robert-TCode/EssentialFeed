//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by TCode on 4/5/22.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
