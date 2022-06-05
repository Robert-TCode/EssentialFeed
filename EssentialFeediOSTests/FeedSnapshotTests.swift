//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by TCode on 4/6/22.
//

import EssentialFeediOS
import XCTest
@testable import EssentialFeed

final class FeedSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
    }

    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        record(snapshot: sut.snapshot(), named: "FEED_WITH_CONTENT")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        record(snapshot: sut.snapshot(), named: "FEED_WITH_ERROR_MESSAGE")
    }

    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        record(snapshot: sut.snapshot(), named: "FEED_WITH_FAILED_IMAGE_LOADING")
    }

    // MARK: Helpers

    private func makeSUT() -> FeedViewController {
        let controller = FeedViewController()

        // Loading the VC on the screen
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()

        return controller
    }

    private func emptyFeed() -> [FeedImageCellController] {
        []
    }

    private func feedWithContent() -> [ImageStub] {
        [
            ImageStub(
                description: "The fox jumped over the lazy dog.",
                location: "London, U.K.",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Nature, peace and an excellent canvas on which you can picture your life.",
                location: "Sibiu, Romania",
                image: UIImage.make(withColor: .green)
            )
        ]
    }

    private func feedWithFailedImageLoading() -> [ImageStub] {
        [
            ImageStub(
                description: "The fox jumped over the lazy dog.",
                location: "London, U.K.",
                image: nil
            ),
            ImageStub(
                description: "Nature, peace and an excellent canvas on which you can picture your life.",
                location: "Sibiu, Romania",
                image: nil
            )
        ]
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }

        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error \(error)", file: file, line: line)
        }
    }
}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}

private extension FeedViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel<UIImage>
    weak var controller: FeedImageCellController?

    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location,
            image: image,
            isLoading: false,
            shouldRetry: image == nil
        )
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}
