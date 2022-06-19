//
//  ImageCommentsSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by TCode on 19/6/22.
//

import EssentialFeediOS
import XCTest
@testable import EssentialFeed

final class ImageCommentsSnapshotTests: XCTestCase {

    func test_listWithComments() {
        let sut = makeSUT()

        sut.display(comments())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_light_extraExtraExtraLarge")
    }

    // MARK: Helpers

    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func comments() -> [CellController] {
        commentControllers().map { CellController(id: UUID(), $0) }
    }

    private func commentControllers() -> [ImageCommentCellController] {
        [
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    date: "500 years ago",
                    username: "A very long username. Unexpected long"
                )
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "Lorem ipsum dolor sit amet.",
                    date: "25 days ago",
                    username: "A username"
                )
            ),
            ImageCommentCellController(
                model: ImageCommentViewModel(
                    message: "👌🏻",
                    date: "3 hours ago",
                    username: "R."
                )
            )
        ]
    }
}
