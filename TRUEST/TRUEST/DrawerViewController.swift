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
                                imageUrl = result.imageUrl else { fatalError() }
                
                postcardsInDrawer.append(PostcardInDrawer(created_time: created_time, title: title, context: context, signature: signature, imageUrl: imageUrl, specific_date: specific_date))
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
        
        DrawerTableView.delegate = self
        DrawerTableView.dataSource = self
        
        self.DrawerTableView.rowHeight = 100

        if self.DrawerTableView != nil {
            self.DrawerTableView.reloadData()
        }
        
     }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postcardsInDrawer.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath) as! DrawerUIViewTableViewCell
        
        let row = indexPath.row
        let thePostcard = postcardsInDrawer[row]
        
        cell.title.text = thePostcard.title
        
        
        return cell
    }
    
}
