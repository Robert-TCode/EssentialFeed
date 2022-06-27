//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by TCode on 20/6/22.
//

import Combine
import EssentialFeed
import EssentialFeediOS
import UIKit

public final class CommentsUIComposer {
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>

    private init() {}

    public static func commentsComposedWith (
        commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
    ) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(loader: { commentsLoader().dispatchOnMainQueue() })
        let refreshController = ListRefreshViewController()
        refreshController.onRefresh = presentationAdapter.loadResource
        let commentsViewController = ListViewController.makeWith(refreshController: refreshController, title: ImageCommentsPresenter.title )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(controller: commentsViewController),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(commentsViewController),
            mapper: { ImageCommentsPresenter.map(comments: $0) }
        )

        return commentsViewController
    }
}

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map({ viewModel in
            CellController(id: viewModel , ImageCommentCellController(model: viewModel))
        }))
    }
}

private extension ListViewController {
    static func makeWith(refreshController: ListRefreshViewController, title: String) -> ListViewController {
        let controller = ListViewController(refreshController: refreshController)
        controller.title = title
        return controller
    }
}
