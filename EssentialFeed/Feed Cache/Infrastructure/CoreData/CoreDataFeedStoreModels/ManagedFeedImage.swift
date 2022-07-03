//
//  ManagedFeedImage+CoreDataClass.swift
//  FeedStoreChallenge
//
//  Created by TCode on 21/3/22.
//  Copyright © 2022 Essential Developer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedFeedImage)
final class ManagedFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
    @NSManaged var data: Data?
	@NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }

        return try first(with: url, in: context)?.data
    }

    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedFeedImage? {
        let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
	static func images(from localFeed: [LocalFeedImage],
	                   in context: NSManagedObjectContext) -> NSOrderedSet {
		let images = NSOrderedSet(array: localFeed.map { local in
			let managedFeedImage = ManagedFeedImage(context: context)
			managedFeedImage.id = local.id
			managedFeedImage.location = local.location
			managedFeedImage.imageDescription = local.description
			managedFeedImage.url = local.URL
            managedFeedImage.data = context.userInfo[local.URL] as? Data
			return managedFeedImage
		})
        context.userInfo.removeAllObjects()
        return images
	}

	func asLocal() -> LocalFeedImage {
		LocalFeedImage(id: self.id,
		               description: self.imageDescription,
		               location: self.location,
                       URL: self.url)
	}

    override func prepareForDeletion() {
        super.prepareForDeletion()

        managedObjectContext?.userInfo[url] = data
    }
}
