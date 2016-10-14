//
//  MailboxViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/12.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class MailboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var MailboxTableView: UITableView!
    var postcardsReceived = [String]()
    var postcardsInMailbox = [PostcardInMailbox]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findUserID()
        
        
        
        // request Postcard from core data
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        
//        let request = NSFetchRequest(entityName: "Postcard")
//        do {
//            let results = try managedContext.executeFetchRequest(request) as! [Postcard]
//            
//            for result in results {
//                guard let  title = result.title,
//                    context = result.context,
//                    signature = result.signature,
//                    created_time = result.created_time,
//                    specific_date = result.specific_date,
//                    image = result.image else { fatalError() }
        
//                postcardsInMailbox.append(PostcardInDrawer(created_time: created_time, title: title, context: context, signature: signature, image: image, specific_date: specific_date))
//            }
//            
//        }catch{
//            fatalError("Failed to fetch data: \(error)")
//        }
        
        
        MailboxTableView.delegate = self
        MailboxTableView.dataSource = self
        
        self.MailboxTableView.rowHeight = 120
        
        if self.MailboxTableView != nil {
            self.MailboxTableView.reloadData()
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postcardsInMailbox.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MailboxCell", forIndexPath: indexPath) as! MailboxTableViewCell
        
        let thePostcard = postcardsInMailbox[indexPath.row]
        
        cell.title.text = thePostcard.title
        cell.title.font = cell.title.font.fontWithSize(12)
        
        cell.imageInSmall.frame = CGRectMake(35, 35, 50, 50)
        cell.imageInSmall.layer.cornerRadius = cell.imageInSmall.frame.height / 2
        cell.imageInSmall.contentMode = .ScaleAspectFill
        cell.imageInSmall.image = UIImage(data: thePostcard.image)
        cell.imageInSmall.clipsToBounds = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        cell.lastEditedLabel.text = dateFormatter.stringFromDate(thePostcard.received_date)
        cell.lastEditedLabel.textColor = UIColor.grayColor()
        cell.lastEditedLabel.font = cell.lastEditedLabel.font.fontWithSize(12)
        
        cell.ContentView.addSubview(cell.imageInSmall)
        
        return cell
    }
    
}


extension MailboxViewController {
    
    func findUserID() {
        // use user uid to find userID in firebase database
        let uid = FIRAuth.auth()!.currentUser!.uid
        var userID = String()
//        var bonds: [String] = []
        
        firebaseDatabaseRef.shared.child("users").queryOrderedByChild("firebase_id").queryEqualToValue(uid).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            userID = snapshot.ref.key
            print("userID:")
            print(userID)
            firebaseDatabaseRef.shared.child("bonds").queryOrderedByChild("receiver").queryEqualToValue(userID).observeEventType(.ChildAdded, withBlock: { snapshot in
                
                guard let  bond = snapshot.value as? NSDictionary,
                                postcard_id = bond["postcard"] as? String
                    else {
                        print("No one has sent a postcard to this user or error in getting bond")
                        return
                }

                print("postcard ID")
                print(postcard_id)
                
                firebaseDatabaseRef.shared.child("postcards").queryOrderedByKey().queryEqualToValue(postcard_id).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
//                    enum downloadError: ErrorType{  //以後有空要來做error handling
//                        case StringConvertError, NSDateConvertError
//                    }
                    
                    guard let  postcard = snapshot.value as? NSDictionary,
                                    context = postcard["context"] as? String,
//                                    created_time = postcard["created_time"] as? NSDate,  // not used
                                    delivered_date = postcard["delivered_date"] as? String,
                                    imageUrl = postcard["image"] as? String,
                                    sender = postcard["sender"] as? String,
                                    signature = postcard["signature"] as? String,
                                    title = postcard["title"] as? String
                    else {
                        print("error in getting postcard")
                        return
                    }
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                    guard let received_date = dateFormatter.dateFromString(delivered_date) else { fatalError() }
                    guard let url = NSURL(string: imageUrl) else { fatalError() }
                    guard let image = NSData(contentsOfURL: url) else { fatalError() }
                    
                    // 目前mailbox的postcard都是線上載下來的，未來要新增user last login date，並把received的postcard都存在core data
                    
                    self.postcardsInMailbox.append(PostcardInMailbox(sender: sender, receiver: userID, received_date: received_date, title: title, context: context, signature: signature, image: image))
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.MailboxTableView.reloadData()
                        print("reloadData")
                    })
                    
                })
                
                
            })
//            print("bonds 空空空")
//            print(bonds)
        })
        
        print("userID: 空空空")
        print(userID)
    }
    
    
    func findBondsWithUserID(userID: String) -> [String] {
        // use userID as receiver to find relatived bonds
        var bonds: [String] = []
        
        firebaseDatabaseRef.shared.child("bonds").queryOrderedByChild("receiver").queryEqualToValue(userID).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            guard let  bond = snapshot.value as? NSDictionary,
                            postcard = bond["postcard"] as? String
                else {
                    print("No one has sent a postcard to this user")
                    return bonds = []
            }
            
            bonds.append(postcard)
        })
        print("bonds in func")
        print(bonds)
        return bonds
    }
}

