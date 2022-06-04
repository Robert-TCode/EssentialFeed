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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        let remoteUrl = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteUrl, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        let localStoreUrl = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")

        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreUrl)
        }

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

        window?.rootViewController = feedViewController
    }

    private func makeRemoteClient() -> HTTPClient {
        switch UserDefaults.standard.string(forKey: "connectivity") {
        case "offline":
            return AlwaysFailingHTTPClient()
        default:
            return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

private class AlwaysFailingHTTPClient: HTTPClient {

    private class Task: HTTPClientTask {
        func cancel() {}
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        return Task()
    }
}
