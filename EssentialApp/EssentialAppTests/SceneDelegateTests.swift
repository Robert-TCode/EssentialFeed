//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by TCode on 4/6/22.
//

@testable import EssentialApp
import EssentialFeediOS
import XCTest

final class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() throws {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
 
        sut.configureWindow()

        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }

    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController

        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is ListViewController, "Expected a feed view controller as the top controller, got \(String(describing: topController)) instead")
    }
}

private class UIWindowSpy: UIWindow {
  var makeKeyAndVisibleCallCount = 0

  override func makeKeyAndVisible() {
    makeKeyAndVisibleCallCount = 1
  }
}
