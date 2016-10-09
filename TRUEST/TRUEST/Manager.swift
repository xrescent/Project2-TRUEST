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

struct PostcardInDrawer {
    let sender: String! = "user'UID on firebase database"
//    let receivers: [String]!
    let created_time: NSDate!
//    let last_edited_time: NSDate!
//    let sent_time: NSDate?
//    let delivered_time: NSDate?
    var title: String!
    var context: String!
    var signature: String!
    var imageUrl: String! //先設成都是non-optional，若無實在塞""來判斷是否有值
//    let audioUrl: NSData?
//    let videoUrl: NSData?
//    let urgency: Int! = 0
//    let deliver_condition: String!
    var specific_date: NSDate!
//    let relative_days: Int?
}

//extension PostcardInDrawer {
//    func toDictionary() -> [String: AnyObject?] {
//        let postcardDictionary: [String: AnyObject]
//        postcardDictionary =  ["sender": self.sender,
//                                            "created_time": self.created_time,
//                                            "title": self.title,
//                                            "context": self.context,
//                                            "signature": self.signature,
//                                            "imageUrl": self.imageUrl,
//                                            "specific_date": self.specific_date!]
//        
//        return postcardDictionary
//    }
//}


//class Manager {
//    
//    func post() {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("Postcards")
//    }
//}


class firebaseDatabaseRef {
    static let shared = FIRDatabase.database().reference()
}

class firebaseStorageRef {
    static let shared = FIRStorage.storage().reference()
}




