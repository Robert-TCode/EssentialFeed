//
//  ListViewController.swift
//  EssentialFeediOS
//
//  Created by TCode on 27/4/22.
//

import UIKit
import EssentialFeed

final public class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    public let errorView = ErrorView()

    private var refreshController: ListRefreshViewController?
    private var loadingControllers = [IndexPath: CellController]()

    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }

    public convenience init(refreshController: ListRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = refreshController?.view

        configureErrorView()

        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.prefetchDataSource = self
        tableView.register(FeedImageCell.self, forCellReuseIdentifier: "FeedImageCell")
        tableView.register(ImageCommentCell.self, forCellReuseIdentifier: "ImageCommentCell")

        refreshController?.refresh()
    }

    private func configureErrorView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.pinToSuperview()
        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
        tableView.tableHeaderView = container
    }

    public override func viewDidLayoutSubviews() {
        tableView.sizeTableHeaderToFit()
    }

    public func display(_ cellControllers: [CellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = cellController(forRowAt: indexPath).dataSource
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let delegate = removeLoadingController(forRowAt: indexPath)?.delegate
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dataSourcePrefetching = cellController(forRowAt: indexPath).dataSourcePrefetching
            dataSourcePrefetching?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let dataSourcePrefetching = removeLoadingController(forRowAt: $0)?.dataSourcePrefetching
            dataSourcePrefetching?.tableView?(tableView, cancelPrefetchingForRowsAt: [$0])
        }
    }

    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }

    private func removeLoadingController(forRowAt indexPath: IndexPath) -> CellController? {
        let controller = loadingControllers[indexPath]
        loadingControllers[indexPath] = nil
        return controller
    }
}

extension ListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.message
    }
}
