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

    let localStoreUrl = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        configureWindow()
    }

    func configureWindow() {
        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        let localStore = try! CoreDataFeedStore(storeURL: localStoreUrl)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)

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
    }

    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
