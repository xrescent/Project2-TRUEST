//
//  AddBondViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/1.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreData

class AddBondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var PostcardImage: UIImageView!
    @IBOutlet weak var AddPhotoPress: UIButton!
    @IBOutlet weak var AddPhotoDescription: UILabel!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var SignatureTextField: UITextField!
    @IBOutlet weak var ContextTextField: UITextView!
    @IBOutlet weak var ConcelPress: UIButton!
    @IBAction func SelectImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    var pickedImage = UIImage()
    var imageData = NSData()
    var imageUrl = String()
    private let imagePicker = UIImagePickerController()
    
    var newPostcard: [Postcard] = []
    var myPostcards = [NSManagedObject]()
    var currentTextOfTitle: String! = "Edit title here"  //先設計成"!"，之後再改成?並在儲存時判斷是否為nil，若為nil則塞預設值給它
    var currentTextOfSignature: String! = "Sign up your name here"
    var currentTextOfContext: String! = "What I want to say is..."
    
    var storageRef: FIRStorageReference!
    private let databaseRef  = FIRDatabase.database().reference()
    private var _refHandle: FIRDatabaseHandle!

    @IBOutlet weak var Toolbar: UIToolbar!
    @IBAction func NextPressed(sender: AnyObject) {
        next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        TitleTextField.delegate = self
        ContextTextField.delegate = self
        SignatureTextField.delegate = self
        imagePicker.delegate = self

        
    }
}


extension AddBondViewController {
    private func setup() {
        self.view.addSubview(ScrollView)
        ScrollView.addSubview(ContentView)
        // setup the UIs'here
        // ConcelPress: UIButton
        guard let concelImage = UIImage(named: "icon_close_button") else { fatalError() }
        let concelImageView = UIImageView(image: concelImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        concelImageView.tintColor = UIColor.whiteColor()
        ConcelPress.setImage(concelImage, forState: .Normal)
        ConcelPress.addTarget(self, action: #selector(AddBondViewController.AbortSelectedImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
}

extension AddBondViewController{
    func next() { //下一步應為寄送條件設定，這裡先暫時做成儲存至core data
        
        newPostcard.append(Postcard(title: currentTextOfTitle, context: currentTextOfContext, signature: currentTextOfSignature, imageUrl: imageUrl))
        
        savePostcard(newPostcard)
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().referenceForURL("gs://truest-625dd.appspot.com/")
    }
    
    func post() { // upload to server
        
        let sendAPostcard: [String: AnyObject] = ["title": currentTextOfTitle,
                                                    "context": currentTextOfContext,
                                                    "signature": currentTextOfSignature,
                                                    "image": 1] //記得image改成storage檔案的檔名
        
        let postcardSentRef = databaseRef.child("postcards").childByAutoId() // 在data base 並產生postcard's uid
        
        let postcardSentUid = postcardSentRef.key
        
        let imagePath = postcardSentUid + "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"// 該圖片存在firebase storage上的名稱
        
        postcardSentRef.setValue(sendAPostcard) //將postcard的資料新增進database
        
        storageRef = FIRStorage.storage().reference().child(imagePath) //指定strage要存的相關資訊
        //在儲存到firebase storage前記得要去更改rule讓read,write = if true
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in //將照片存入storage中
            
            if let error = error {
                print("Error upload image: \(error)")
                return
            }
        }
        
            print("UID: \(postcardSentUid)")
    }
    
//    func request() {          下載
//        _refHandle = self.databaseRef.child("postcards").observeEventType(.ChildAdded, withBlock: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
////            strongSelf.myPostcards.append(snapshot)
//            })
//    }
    
    
    func savePostcard(postcardToSave: [Postcard]) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Postcard", inManagedObjectContext: managedContext)
        
        let newPostcard = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        let postcardToSaveInfo = postcardToSave[0].toDictionary()
        
//        newPostcard.setValue(<#T##value: AnyObject?##AnyObject?#>, forKey: <#T##String#>)
        for (key, value) in postcardToSaveInfo {
            newPostcard.setValue(value, forKey: key)
        }
        
        do {
            try managedContext.save()
            
            myPostcards.append(newPostcard)
        } catch {
            print("Error in saving newPostcard into core data")
        }
        
        let aa = myPostcards
        print("core data Postcard: \(aa)")
    }
    
}


extension AddBondViewController{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // iOS 8.0用UIImagePickerControllerReferenceURL，else用OriginalImage
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { fatalError() }
        PostcardImage.contentMode = .ScaleToFill
        PostcardImage.image = pickedImage
        self.pickedImage = pickedImage as UIImage
        imageData = UIImageJPEGRepresentation(pickedImage, 1.0)! //將所選取的image轉型成NSData，不壓縮
        
        guard let url = info[UIImagePickerControllerReferenceURL] as? NSURL else { fatalError() }
        imageUrl = url.absoluteString
        
        AddPhotoDescription.hidden = true
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
    }

    
    @objc private func AbortSelectedImage(sender: UIButton) {
        AddPhotoDescription.hidden = false
        PostcardImage.image = UIImage() // = UIImage(named: " ")
        self.dismissViewControllerAnimated(false, completion: nil)
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    在UITextView中只有一個return鍵，但user可能會同時需要「斷行」、「結束」兩個功能
//    // return keyboard when 'return' pressed in UITextView
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        } else {
//            return true
//        }
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField {
        case TitleTextField:
            ScrollView.setContentOffset(CGPointMake(0, 100), animated: true)
        case SignatureTextField:
            ScrollView.setContentOffset(CGPointMake(0, 2), animated: true)
        default: break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case TitleTextField:
            currentTextOfTitle = textField.text
        case SignatureTextField:
            currentTextOfSignature = textField.text
        default:
            break
        }
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        ScrollView.setContentOffset(CGPointMake(0, 150), animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        currentTextOfContext = textView.text
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}