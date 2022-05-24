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
	static func images(from localFeed: [LocalFeedImage],
	                   in context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: localFeed.map { local in
			let managedFeedImage = ManagedFeedImage(context: context)
			managedFeedImage.id = local.id
			managedFeedImage.location = local.location
			managedFeedImage.imageDescription = local.description
			managedFeedImage.url = local.URL
			return managedFeedImage
		})
	}

	func asLocal() -> LocalFeedImage {
		LocalFeedImage(id: self.id,
		               description: self.imageDescription,
		               location: self.location,
                       URL: self.url)
	}
}
