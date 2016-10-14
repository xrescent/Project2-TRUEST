//
//  ContactsViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/13.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ContactsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var CollectionView: UICollectionView!

    var myFriends: [Friends] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
    
        let stringUrl = "https://firebasestorage.googleapis.com/v0/b/truest-625dd.appspot.com/o/-KTm_8FrWO9NfS-6lN5b?alt=media&token=38b56f58-2ae7-49ba-9dd2-72ba535b0dfc"
        let imageUrl = NSURL(string: stringUrl)!
        let data = NSData(contentsOfURL: imageUrl)!
        
        myFriends = [Friends(name: "Jialing Tan", user_uid: "H8Tn2PP7KoZ7ipUK5sf63nne1Fu2", fbID: "100000557426640", email: "jialing.tan@msa.hinet.net", image: data), Friends(name: "Michael", user_uid: "user_uid", fbID: "fbID", email: "email", image: data), Friends(name: "Andrew", user_uid: "user_uid", fbID: "fbID", email: "email", image: data)]
        
        firebaseDatabaseRef.shared.child("users").queryOrderedByChild("fbID").observeEventType(.ChildAdded, withBlock: { snapshot in
            
            guard let  user = snapshot.value as? NSDictionary,
                            fbID = user["fbID"] as? String
                else {
                    print("error in finding user's fbID")
                    return
            }
            
            print(fbID)
            
            
            
        })

        CollectionView.delegate = self
        CollectionView.dataSource = self
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return postcardInMailbox.count
        return myFriends.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContactsCell", forIndexPath: indexPath) as! ContactsCollectionViewCell
        
        let row = indexPath.row
        
        let theFriend = myFriends[row]
        
        cell.setup()
        cell.imageInSmall.image = UIImage(data: theFriend.image)
        cell.contactName.text = theFriend.name
        
        return cell
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 375 110
        if let layout = CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let itemWidth = 110
            let itemHeight = itemWidth
            let edgeSpacing = (view.bounds.width - 334) / 2
            layout.sectionInset = UIEdgeInsets(top: 20, left: edgeSpacing, bottom: 15, right: edgeSpacing)
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 2
            layout.invalidateLayout()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle if a friend is selected
    }
}
