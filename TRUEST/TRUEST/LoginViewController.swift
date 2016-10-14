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
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingSpinner.hidden = true
        
        self.hideLoginButtons(true)
        
/////////////// 判斷user是否登入過，給予不同的開場畫面 ///////////
        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
            if user != nil {
                // user is signed in
                // move user to homeViewController
                switchViewController(from: self, to: "AddBondViewController") // ContactsViewController

            } else {
                // user is not signed in
                // setup UIs for LoginViewController
                self.hideLoginButtons(false)
                self.setup()
            }
        }
///////////////////////////////////////////////////////////////////////////////////////////////////
//        // log out
//        @IBAction func didTapLogout(sender: AnyObject) {
//            try! FIRAuth.auth()!.signOut()
//            FBSDKAccessToken.setCurrentAccessToken(nil)
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let viewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController")
//            self.presentViewController(viewController, animated: true, completion: nil)
//        }
///////////////////////////////////////////////////////////////////////////////////////////////////
        
//        setup()
    }
    
}

extension LoginViewController {
    
    private func hideLoginButtons(decision: Bool) {
        loginDescription.hidden = decision
        button1.hidden = decision
        facebookButton.hidden = decision
        facebookLabel.hidden = decision
        button3.hidden = decision
        button4.hidden = decision
    }
    
    
    
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
        
        self.loadingSpinner.hidden = true
        self.loadingSpinner.stopAnimating()
    }
}


extension LoginViewController {
    // when clicking Facebook login button
    @IBAction func facebookPressed(sender: AnyObject) {
        loginWithFacebook()
    }
    
}


extension LoginViewController {
    
    private func loginWithFacebook() {
        self.hideLoginButtons(true)
        
        self.loadingSpinner.startAnimating()
        
        // get Facebook login authentication
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logInWithReadPermissions(["public_profile", "email"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            
            if let error = error {
                print("FB login error: \(error)")
                self.hideLoginButtons(false)
                self.loadingSpinner.stopAnimating()
                return
            }
            
            if result.isCancelled {
                print("Cancle button pressed")
                self.hideLoginButtons(false)
                self.loadingSpinner.stopAnimating()
            } else {
                // permission get
                print("FB logged in")
                
                // using fb access token to sign in to firebase
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("FB access token get")
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    print("sign in firebase with FB")
                    self.getFBUserData()
                }
                
                
                // link to the page (UIViewController) we want  有一個待改進之處：切換畫面時會短暫回到LoginViewController在導到我們指定的畫面
                self.dismissViewControllerAnimated(true, completion: nil)
                
                switchViewController(from: self, to: "AddBondViewController")
            }
        })
        
    }
    
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
                print("FB user info get")
                
                self.cleanUserInfo()
                
                // get user's firebase UID
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { fatalError() }
                
                // convert those data's format so we can save it into core data
                let userInfo: [String: AnyObject] =  [ "id": uid, "fbID": id, "name": name, "email": email, "fbProfileLink": link, "pictureUrl": url ]
                
                // save those data into core data: FBUser
                self.setupUserInfo(userInfo)

//// method: save into userDefaults
//let userDefaults_fbLoginData = NSUserDefaults.standardUserDefaults()
//userDefaults_fbLoginData.setObject(name, forKey: "FB_userName")
//userDefaults_fbLoginData.setObject(id, forKey: "FB_userID")
//userDefaults_fbLoginData.setObject(email, forKey: "FB_userEmail")
//userDefaults_fbLoginData.setObject(link, forKey: "FB_userLink")
//userDefaults_fbLoginData.setObject(url, forKey: "FB_userPictureURL")
                
                self.uploadFBUserInfo() //之後要再加一個判斷if該user已經在firebase上存在了，就不再新增而是updata (應另寫一個func)
                
            })
        }
    }
}

extension UIViewController {
    
    // delete all data in FBUser. because it is allowed only one user at the same time
    private func cleanUserInfo() {
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
            print("deleting user info in core data")
        } catch {
            print("Error in updating FBUser deletion")
        }
    }
    
    // saving data into core data: FBUser
    private func setupUserInfo(userInfo: [String: AnyObject]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("FBUser", inManagedObjectContext: managedContext)
        
        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        for (key, value) in userInfo {
            user.setValue(value, forKey: key)
        }
        
        do {
            try managedContext.save()
            print("saving user info in core data")
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

    
    private func uploadFBUserInfo() {
        let fbUserInfoSentRef = FirebaseDatabaseRef.shared.child("users").childByAutoId()  //在database產生一個user uid。註：不用auth()的uid是因為未來可能會讓user用多種方式登入，此時一個user就會有多個auth的uid
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "FBUser")
        
        var tempUserInfo = [String: AnyObject]()
        
        do {
            let results = try managedContext.executeFetchRequest(request) as! [FBUser]

            print(results.count)
            
            tempUserInfo["fbID"] = results[0].fbID
            tempUserInfo["name"] = results[0].name
            tempUserInfo["email"] = results[0].email
            tempUserInfo["pictureUrl"] = results[0].pictureUrl
            tempUserInfo["firebase_id"] = results[0].id
            
            fbUserInfoSentRef.setValue(tempUserInfo)
            print("upload FB user info to firebase")
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }

    }

}













