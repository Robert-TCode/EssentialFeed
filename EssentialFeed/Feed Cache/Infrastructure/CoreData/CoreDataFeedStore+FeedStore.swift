//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by TCode on 24/5/22.
//

import CoreData

extension CoreDataFeedStore: FeedStore {

    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(
                Result {
                    try ManagedCache.find(in: context).map {
                        CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                    }
                }
            )
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)

                try context.save()
                completion(.success(()))
            } catch {
                context.rollback()
                completion(.failure(error))
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try ManagedCache.find(in: context)
                    .map(context.delete)
                    .map(context.save)

                completion(.success(()))
            } catch {
                context.rollback()
                completion(.failure(error))
            }
        }
    }
}
