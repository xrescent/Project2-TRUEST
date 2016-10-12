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
    var postcardsInMailbox = [PostcardInDrawer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        print("uid is not gonna be used")
        print(uid)
        firebaseDatabaseRef.shared.child("bonds").queryOrderedByChild("receiver").queryEqualToValue("-KTmZQPryCOPyhlDFsAI").observeEventType(.ChildAdded, withBlock: { snapshot in
            print("snapshot: ")
            print(snapshot)
            
            guard let  bond = snapshot.value as? NSDictionary,
                            receiver = bond["receiver"] else { fatalError() }
            
            print("receiver")
            print(receiver)

//            guard let postcardID = snapshot.value!["postcard"] as? String else { fatalError() }
//            self.postcardsReceived.append(postcardID)
        
        })
        print("download postcard")
        downloadPostcards()
        
        //    func request() {          下載
        //        _refHandle = firebaseDatabaseRef.shared.child("postcards").observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
        //            guard let strongSelf = self else { return }
        ////            strongSelf.myPostcards.append(snapshot)
        //            })
        //    }

        
        
        // request Postcard from core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Postcard")
        do {
            let results = try managedContext.executeFetchRequest(request) as! [Postcard]
            
            for result in results {
                guard let  title = result.title,
                    context = result.context,
                    signature = result.signature,
                    created_time = result.created_time,
                    specific_date = result.specific_date,
                    image = result.image else { fatalError() }
                
                postcardsInMailbox.append(PostcardInDrawer(created_time: created_time, title: title, context: context, signature: signature, image: image, specific_date: specific_date))
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
        
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
        
        //        cell.cellBackground.frame = CGRectMake(20, 20, self.view.frame.width - 40 , 80)
        
        cell.title.text = thePostcard.title
        cell.title.font = cell.title.font.fontWithSize(12)
        
        cell.imageInSmall.frame = CGRectMake(35, 35, 50, 50)
        cell.imageInSmall.layer.cornerRadius = cell.imageInSmall.frame.height / 2
        cell.imageInSmall.contentMode = .ScaleAspectFill
        cell.imageInSmall.image = UIImage(data: thePostcard.image)
        cell.imageInSmall.clipsToBounds = true
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        cell.lastEditedLabel.text = dateFormatter.stringFromDate(thePostcard.created_time)
        cell.lastEditedLabel.textColor = UIColor.grayColor()
        cell.lastEditedLabel.font = cell.lastEditedLabel.font.fontWithSize(12)
        
        cell.ContentView.addSubview(cell.imageInSmall)
        
        return cell
    }
    
}


