//
//  Manager.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/3.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Postcard {
    let sender: String! = "user'UID on firebase database"
//    let receivers: [String]!
//    let creation_time: NSDate!
//    let last_edit_time: NSDate!
//    let sent_time: NSDate?
//    let delivered_time: NSDate?
    let title: String!
    let context: String!
    let signature: String!
    let image: NSData?
//    let audio: NSData?
//    let video: NSData?
//    let urgency: Bool! = false
//    let deliver_condition: String!
//    let specific_date: NSDate?
//    let relative_days: Int?
}

//class Manager {
//    
//    func post() {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("Postcards")
//    }
//}







