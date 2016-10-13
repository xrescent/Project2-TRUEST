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
    
        let stringUrl = "https://www.facebook.com/photo.php?fbid=1290337507661484&set=a.155537521141494.36840.100000557426640&type=3&theater"
        let imageUrl = NSURL(string: stringUrl)!
        let data = NSData(contentsOfURL: imageUrl)!
        
        myFriends = [Friends(name: "Jialing Tan", user_uid: "H8Tn2PP7KoZ7ipUK5sf63nne1Fu2", fbID: "100000557426640", email: "jialing.tan@msa.hinet.net", image: data), Friends(name: "Michael", user_uid: "user_uid", fbID: "fbID", email: "email", image: data), Friends(name: "Andrew", user_uid: "user_uid", fbID: "fbID", email: "email", image: data)]

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
        cell.imageInSmall.contentMode = .ScaleAspectFill
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
