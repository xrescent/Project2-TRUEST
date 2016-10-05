//
//  Postcard+CoreDataProperties.swift
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

extension Postcard {

    @NSManaged var sender: String?
    @NSManaged var receivers: NSObject?
    @NSManaged var created_time: NSDate?
    @NSManaged var last_edited_time: NSDate?
    @NSManaged var sent_time: NSDate?
    @NSManaged var delivered_time: NSDate?
    @NSManaged var title: String?
    @NSManaged var context: String?
    @NSManaged var signature: String?
    @NSManaged var imageUrl: String?
    @NSManaged var audio: String?
    @NSManaged var video: String?
    @NSManaged var urgency: NSNumber?
    @NSManaged var deliver_condition: NSNumber?
    @NSManaged var specific_date: NSDate?
    @NSManaged var relative_days: NSNumber?
    @NSManaged var postcard_uid: String?

}
