//
//  FBUser+CoreDataProperties.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/4.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FBUser {

    @NSManaged var fbID: String?
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var fbProfileLink: String?
    @NSManaged var pictureUrl: String?
    @NSManaged var id: String?

}
