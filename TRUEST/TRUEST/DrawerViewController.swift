//
//  DrawerViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import CoreData

class DrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var DrawerTableView: UITableView!
    var postcardsInDrawer = [PostcardInDrawer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                
                postcardsInDrawer.append(PostcardInDrawer(created_time: created_time, title: title, context: context, signature: signature, image: image, specific_date: specific_date))
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
        
        DrawerTableView.delegate = self
        DrawerTableView.dataSource = self
        
        self.DrawerTableView.rowHeight = 120

        if self.DrawerTableView != nil {
            self.DrawerTableView.reloadData()
        }
        
     }
    
    
    @IBAction func ViewMailbox(sender: AnyObject) {
        switchViewController(from: self, to: "MailboxViewController")
    }
    @IBAction func Add(sender: AnyObject) {
        switchViewController(from: self, to: "AddBondViewController")
    }
    @IBAction func ViewContacts(sender: AnyObject) {
        switchViewController(from: self, to: "ContactsViewController")
    }
    
    
    
    
    
    
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postcardsInDrawer.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath) as! DrawerTableViewCell
        
        let thePostcard = postcardsInDrawer[indexPath.row]
        
//        cell.cellBackground.frame = CGRectMake(20, 20, self.view.frame.width - 40 , 80)  //之後改成依device的大小自動變化
        
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
