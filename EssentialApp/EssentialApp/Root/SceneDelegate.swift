//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by TCode on 25/5/22.
//

import CoreData
import EssentialFeed
import EssentialFeediOS
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer.defaultDirectoryURL()
                                           .appendingPathComponent("feed-store.sqlite")
        )
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        configureWindow()
    }

    func configureWindow() {
        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: httpClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)

        let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        let composedFeedLoader = FeedLoaderWithFallbackComposite(
            primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader),
            fallback: localFeedLoader
        )
        let composedImageLoader = FeedImageDataLoaderWithFallbackComposite(
            primary: FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader),
            fallback: localImageLoader
        )
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: composedFeedLoader,
            imageLoader: composedImageLoader
        )

        window?.rootViewController = UINavigationController(rootViewController: feedViewController)
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
}
