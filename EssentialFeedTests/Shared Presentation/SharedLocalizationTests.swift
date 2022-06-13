//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by TCode on 12/6/22.
//

import EssentialFeed
import XCTest

final class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeyAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }
 
    private class DummyView: ResourceView {
        typealias ResourceViewModel = Any

        func display(_ viewModel: Any) {}
    }
   
}
