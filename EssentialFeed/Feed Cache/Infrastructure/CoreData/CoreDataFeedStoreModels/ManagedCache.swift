//
//  ManagedCache+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by TCode on 21/3/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}

    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }

	static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
		return ManagedCache(context: context)
	}

	var localFeed: [LocalFeedImage] {
		return self.feed
			.compactMap { $0 as? ManagedFeedImage }
			.map { $0.asLocal() }
	}
}
