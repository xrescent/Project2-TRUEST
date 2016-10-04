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
//    let created_time: NSDate!
//    let last_edited_time: NSDate!
//    let sent_time: NSDate?
//    let delivered_time: NSDate?
    let title: String!
    let context: String!
    let signature: String!
    let imageUrl: String! //先設成都是non-optional，若無實在塞""來判斷是否有值
//    let audioUrl: NSData?
//    let videoUrl: NSData?
//    let urgency: Int! = 0
//    let deliver_condition: String!
//    let specific_date: NSDate?
//    let relative_days: Int?
}

extension Postcard {
    func toDictionary() -> [String: AnyObject?] {
        let postcardDictionary: [String: AnyObject]
        postcardDictionary =  ["sender": self.sender,
                                            "title": self.title,
                                            "context": self.context,
                                            "signature": self.signature,
                                            "imageUrl": self.imageUrl]
        
        return postcardDictionary
    }
}

/*
 建立兩個storage table
 core data是local的
 firebase是要上傳server的
 定義好兩者各自的data type
 
 1)先存好存到core data
 2)寫一個model來轉型core data -> firebase
 3)上傳存到firebase
*/

//class Manager {
//    
//    func post() {
//        let databaseRef = FIRDatabase.database().reference()
//        databaseRef.child("Postcards")
//    }
//}








