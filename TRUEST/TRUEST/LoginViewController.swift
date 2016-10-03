//
//  ViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/9/26.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var loginDescription: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

extension LoginViewController {
    private func setup() {
        facebookLabel.text = "f"
        facebookLabel.font = UIFont(name: (facebookLabel.font?.fontName)!, size: 30)
        facebookLabel.textAlignment = .Center
        facebookLabel.textColor = UIColor.whiteColor()
        facebookLabel.backgroundColor = UIColor.ascFacebookLogoColor()
        facebookLabel.layer.masksToBounds = true
        facebookLabel.layer.cornerRadius = facebookLabel.frame.width/2  // it's a circle base on it's size 
        
        facebookButton.setTitle("", forState: .Normal) // use setTitle to set button's title, don't use titleLabel
        facebookButton.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0).CGColor
        
        
    }
}


extension LoginViewController {
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        // create a reference to a Firebase location
        let myRootRef = FIRDatabase.database().reference()
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile", "email"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            if let error = error {
                print("FB login error: \(error)")
                return
            }
            if result.isCancelled {
                print("Cancle button pressed")
            } else {
//                self.dismissViewControllerAnimated(true, completion: nil)
                self.getFBUserData()
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //                _= AppDelegate.switchToBondViewController()
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
//                myRootRef.
            }
        })
    }
}


extension LoginViewController {
    private func getFBUserData() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let parameters = ["fields": "name, id, picture.type(large), email, link"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, result, error) -> Void in
                if let error = error {
                    print("FB user data access error: \(error)")
                    return
                }
//                let a = result["name"]
//                print("\(a)")
//                
//                print("\(result)")
                guard let  result = result as? NSDictionary,    // The value property is a id (AnyObject) and you might need to cast it to dictionary yourself.
                                name = result["name"] as? String,
                                id = result["id"] as? String,
                                email = result["email"] as? String,
                                link = result["link"] as? String,
                                picture = result["picture"] as? NSDictionary,
                                data = picture["data"] as? NSDictionary,
                                url = data["url"] as? String
                    else {
                let error = error
                print("Error: \(error)")
                        return
                }
                
                print("\(name)")
//
//                let userDefaults_fbLoginData = NSUserDefaults.standardUserDefaults()
//                     userDefaults_fbLoginData.setObject(name, forKey: "FB_userName")
//                     userDefaults_fbLoginData.setObject(id, forKey: "FB_userID")
//                     userDefaults_fbLoginData.setObject(email, forKey: "FB_userEmail")
//                     userDefaults_fbLoginData.setObject(link, forKey: "FB_userLink")
//                     userDefaults_fbLoginData.setObject(url, forKey: "FB_userPictureURL")
            })
        }
    }
}

