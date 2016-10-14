//
//  Manager.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/3.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import CoreData


struct PostcardInDrawer {
    let sender: String! = FIRAuth.auth()?.currentUser?.uid
//    let receivers: [String]!
    let created_time: NSDate!
//    let last_edited_time: NSDate!
//    let sent_time: NSDate?
//    let delivered_time: NSDate?
    var title: String!
    var context: String!
    var signature: String!
    var image: NSData!
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
class PostcardInMailbox {
    var sender: String!
    var receiver: String!
    //    var created_time: NSDate!
    //    let last_edited_time: NSDate!
    //    let sent_time: NSDate?
    var received_date: NSDate!  // 與寄出時不一樣
    var title: String!
    var context: String!
    var signature: String!
    var image: NSData!
    //    let audioUrl: NSData?
    //    let videoUrl: NSData?
    //    let urgency: Int! = 0
    //    let deliver_condition: String!
    //    var specific_date: NSDate!
    //    let relative_days: Int?
    init (sender: String, receiver: String, received_date: NSDate, title: String, context: String, signature: String, image: NSData) {
        self.sender = sender
        self.receiver = receiver
        self.received_date = received_date
        self.title = title
        self.context = context
        self.signature = signature
        self.image = image
    }
}


class Friends {

    var name: String!
    var user_uid: String!
    var fbID: String!
    var email: String!
    var image: NSData!
    
    init (name: String, user_uid: String, fbID: String, email: String, image: NSData) {
        self.name = name
        self.user_uid = user_uid
        self.fbID = fbID
        self.email = email
        self.image = image
    }

}


class FirebaseDatabaseRef {
    static let shared = FIRDatabase.database().reference()
}

class FirebaseStorageRef {
    static let shared = FIRStorage.storage().reference()
}


protocol CurrentUserDelegate: class {
    func manager(manager: CurrentUserManager, userFBid: String)
}



class CurrentUserManager {
    static let shared = CurrentUserManager()

    typealias GetUserID = (uid: String, fbID: String) -> Void
    
    func getUserID(completion completion: GetUserID) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "FBUser")
        do {
            let results = try managedContext.executeFetchRequest(request) as! [FBUser]
            
            for result in results {
                guard let  fbID = result.fbID else { fatalError() }
                
                dispatch_async(dispatch_get_main_queue(), {

                    let userUID = (FIRAuth.auth()?.currentUser?.uid)!
                    
                    completion(uid: userUID, fbID: fbID)
                    
                })
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
}




extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: CGPoint(x: originX, y: originY), size: size)
    }
}



// 嘗試將開啟新UIViewController做成一個func
func switchViewController(from originalViewController: UIViewController, to identifierOfDestinationViewController: String!) {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let destinationViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(identifierOfDestinationViewController)
    
    destinationViewController.modalPresentationStyle = .CurrentContext
    destinationViewController.modalTransitionStyle = .CoverVertical
    
    originalViewController.presentViewController(destinationViewController, animated: true, completion: nil)
}

//以後要把downloadPostcards寫在背景執行
//func downloadPostcards() {
//    firebaseStorageRef.shared.child("-KTm_8FrWO9NfS-6lN5b").dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//        if error != nil {
//            print("error in downloading postcard")
//        } else {
//            print("data")
//            print(data)
//        }
//    }
//}
