//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 12/6/22.
//

import EssentialFeed
import XCTest

final class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeyAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        typealias ResourceViewModel = Any

        func display(_ viewModel: Any) {}
    }

}
