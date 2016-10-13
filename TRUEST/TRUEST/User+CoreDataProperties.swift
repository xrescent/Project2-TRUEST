//
//  User+CoreDataProperties.swift
//  
//
//  Created by MichaelRevlis on 2016/10/13.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var fbID: String?
    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var image: NSData?
    @NSManaged var user_uid: String?

}
