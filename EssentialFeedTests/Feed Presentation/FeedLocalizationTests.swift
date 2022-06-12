//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by TCode on 12/5/22.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeyAndValuesForAllSupportedLocalizations() {
        let table = "Feed" 
        let bundle = Bundle(for: FeedPresenter.self) 

        assertLocalizedKeysAndValuesExist(in: bundle, table)
    }
}
