//
//  ViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/9/26.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var loginDescription: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
/////////////// 判斷user是否登入過，給予不同的開場畫面 ///////////
//        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
//            if user != nil {
//                // user is signed in
//                // move user to homeViewController
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AddBondViewController")
//                
//                self.presentViewController(homeViewController, animated: true, completion: nil)
//
//            } else {
//                // user is not signed in
//                // setup UIs for LoginViewController
//                self.setup()
//            }
//        }
///////////////////////////////////////////////////////////////////////////////////////////////////
        
        setup()
    }
    
}

extension LoginViewController {
    private func setup() {
        
        // login label for Facebook
        facebookLabel.text = "f"
        facebookLabel.font = UIFont(name: (facebookLabel.font?.fontName)!, size: 30)
        facebookLabel.textAlignment = .Center
        facebookLabel.textColor = UIColor.whiteColor()
        facebookLabel.backgroundColor = UIColor.ascFacebookLogoColor()
        facebookLabel.layer.masksToBounds = true
        facebookLabel.layer.cornerRadius = facebookLabel.frame.width/2  // it's a circle base on it's size 
        
        // a invisible login button for Facebook
        facebookButton.setTitle("", forState: .Normal) // use setTitle to set button's title, don't use titleLabel
        facebookButton.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0).CGColor
        
    }
}


extension LoginViewController {
    // when clicking Facebook login button
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        // get Facebook login authentication
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["public_profile", "email"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            
            if let error = error {
                print("FB login error: \(error)")
                return
            }
            
            if result.isCancelled {
                print("Cancle button pressed")
            } else {
                // permission get
                self.dismissViewControllerAnimated(true, completion: nil)
                
                self.getFBUserData()
                
                // link to the page (UIViewController) we want  有一個待改進之處：切換畫面時會短暫回到LoginViewController在導到我們指定的畫面
                switchViewController(from: self, to: "AddBondViewController")
                
                // using fb access token to sign in to firebase
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                }
                
                self.uploadFBUserInfo() //之後要再加一個判斷if該user已經在firebase上存在了，就不再新增而是updata (應另寫一個func)
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

                guard let  result = result as? NSDictionary,
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
                
                // get user's firebase UID
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { fatalError() }
                
                // convert those data's format so we can save it into core data
                let userInfo: [String: AnyObject] =  [ "id": uid, "fbID": id, "name": name, "email": email, "fbProfileLink": link, "pictureUrl": url ]
                
                // save those data into core data: FBUser
                self.cleanUserInfo()
                self.setupUserInfo(userInfo)

//// method: save into userDefaults
//let userDefaults_fbLoginData = NSUserDefaults.standardUserDefaults()
//userDefaults_fbLoginData.setObject(name, forKey: "FB_userName")
//userDefaults_fbLoginData.setObject(id, forKey: "FB_userID")
//userDefaults_fbLoginData.setObject(email, forKey: "FB_userEmail")
//userDefaults_fbLoginData.setObject(link, forKey: "FB_userLink")
//userDefaults_fbLoginData.setObject(url, forKey: "FB_userPictureURL")
            })
        }
    }
}

extension UIViewController {
    
    // delete all data in FBUser. because it is allowed only one user at the same time
    func cleanUserInfo() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "FBUser")
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [FBUser]
            
            for result in results {
                managedContext.deleteObject(result)
            }
        }catch {
            print("Error in deleting core data: FBUser")
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Error in updating FBUser deletion")
        }
    }
    
    // saving data into core data: FBUser
    func setupUserInfo(userInfo: [String: AnyObject]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("FBUser", inManagedObjectContext: managedContext)
        
        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        for (key, value) in userInfo {
            user.setValue(value, forKey: key)
        }
        
        do {
            try managedContext.save()
        } catch {
            print("Error in saving userInfo into core data")
        }
////////////////////////////////////////////////////////////////////////////////////////////////////
//// request core data we just saved to check if we do save it/////
////////////////////////////////////////////////////////////////////////////////////////////////////
        let request = NSFetchRequest(entityName: "FBUser")
        do {
            let results = try managedContext.executeFetchRequest(request) as! [FBUser]
            
            let c = results.count
            print("FBUser number: \(c)")
            print("\(results[0])")
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
////////////////////////////////////////////////////////////////////////////////////////////////////
    }

    
    func uploadFBUserInfo() {
        let fbUserInfoSentRef = firebaseDatabaseRef.shared.child("users").childByAutoId()  //在database產生一個user uid。註：不用auth()的uid是因為未來可能會讓user用多種方式登入，此時一個user就會有多個auth的uid
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "FBUser")
        
        var tempUserInfo = [String: AnyObject]()
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [FBUser]

            tempUserInfo["fbID"] = results[0].fbID
            tempUserInfo["name"] = results[0].name
            tempUserInfo["email"] = results[0].email
            tempUserInfo["pictureUrl"] = results[0].pictureUrl
            
            fbUserInfoSentRef.setValue(tempUserInfo)
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }

    }

    



}



// 嘗試將開啟新UIViewController做成一個func
func switchViewController(from originalViewController: UIViewController, to identifierOfDestinationViewController: String!) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let destinationViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(identifierOfDestinationViewController)

        originalViewController.presentViewController(destinationViewController, animated: true, completion: nil)
    }










