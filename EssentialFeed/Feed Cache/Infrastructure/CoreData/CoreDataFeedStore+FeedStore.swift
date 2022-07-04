//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by TCode on 24/5/22.
//

import CoreData

extension CoreDataFeedStore: FeedStore {

    public func retrieve() throws -> CachedFeed? {
        try performSync { context in
            Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                do {
                    try context.save()
                } catch {
                    context.rollback()
                    throw error
                }
            }
        }
    }

    public func deleteCachedFeed() throws {
        try performSync { context in
            Result {
                do {
                    try ManagedCache.deleteCache(in: context)
                } catch {
                    context.rollback()
                    throw error
                }
            }
        }
    }
}
