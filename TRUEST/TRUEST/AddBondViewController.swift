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
    @IBOutlet weak var LabelForShadow: UILabel!
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
    
    @IBOutlet weak var DeliverConditionContentView: UIView!
    @IBOutlet weak var ConditionImageView: UIImageView!
    @IBOutlet weak var ConditionSetupContextView: UIView!
    @IBOutlet weak var ConditionInputBackground: UILabel!
    @IBOutlet weak var ConditionInputTextField: UITextField!
    @IBOutlet weak var FinishDateSelectButton: UIButton!
    
    
    @IBOutlet weak var Button1: UIBarButtonItem!
    @IBOutlet weak var Button2: UIBarButtonItem!
    @IBOutlet weak var Button3: UIBarButtonItem!
    @IBOutlet weak var Button4: UIBarButtonItem!
    @IBOutlet weak var Button5: UIBarButtonItem!
    
    
    private var pickedImage = UIImage()
    private var imageData = NSData()
    private var imageUrl = String()
    private let imagePicker = UIImagePickerController()
    
//    private var newPostcard: PostcardInDrawer
    private var newPostcard: [PostcardInDrawer] = []
//    private var myPostcards = [NSManagedObject]()
    private var currentTextOfTitle: String! = "Edit title here"  //先設計成"!"，之後再改成?並在儲存時判斷是否為nil，若為nil則塞預設值給它
    private var currentTextOfSignature: String! = "Sign up your name here"
    private var currentTextOfContext: String! = "What I want to say is..."
    private var _refHandle: FIRDatabaseHandle!
    private var dateFormatter = NSDateFormatter()
    private var delivered_date = NSDate()


    @IBOutlet weak var Toolbar: UIToolbar!
    @IBAction func CheckDrawer(sender: AnyObject) {
        print("check Drawer")
        switchViewController(from: self, to: "DrawerViewController")
    }
    @IBAction func CheckMailbox(sender: AnyObject) {
        print("check Mailbox")
        switchViewController(from: self, to: "MailboxViewController")
    }
    @IBAction func NextPressed(sender: AnyObject) {
        print("NEXT pressed")
        next()
    }
    @IBAction func SavePressed(sender: AnyObject) {
        print("SAVE pressed")
        savePostcard(newPostcard)
    }
    @IBAction func UploadPressed(sender: AnyObject) {
        print("SEND pressed")
        sent(currentPostcard: newPostcard)
    }

    @IBAction func ConditionInputFieldClicked(sender: UITextField) {
        ConditionInputTextField.text = ""
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        
        let datePickerView = UIDatePicker(frame: CGRectMake(0, 30, 0, 0))
        //        datePickerView.backgroundColor = UIColor.whiteColor()
        
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 30))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        inputView.addSubview(datePickerView)
        inputView.addSubview(doneButton)
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        datePickerView.minuteInterval = 30  //設定每30分鐘為一個間隔
        
        sender.inputView = inputView
        
        datePickerView.addTarget(self, action: #selector(AddBondViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        doneButton.addTarget(self, action: #selector(AddBondViewController.finishSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    // 透明的button以偵測使用者已選好時間日期了
//    @IBAction func FinishDateSelect(sender: AnyObject) {
//        delivered_date = dateFormatter.dateFromString(ConditionInputField.text!)!
//        
//        self.newPostcard[0].specific_date = delivered_date
//        
//        ConditionInputField.resignFirstResponder()
//        //有傳資料但是沒有收datepicker
//    }
    
    
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
        
        DeliverConditionContentView.hidden = true
        
        // ConcelPress: UIButton
        guard let concelImage = UIImage(named: "icon_close_button") else { fatalError() }
        let concelImageView = UIImageView(image: concelImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        concelImageView.tintColor = UIColor.whiteColor()
        ConcelPress.setImage(concelImage, forState: .Normal)
        ConcelPress.addTarget(self, action: #selector(AddBondViewController.AbortSelectedImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        // LabelForShadow
        LabelForShadow.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        LabelForShadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        LabelForShadow.layer.shadowOpacity = 1.0
        LabelForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // ConditionInputBackground
        ConditionInputBackground.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        ConditionInputBackground.layer.borderColor = UIColor.blackColor().CGColor
        ConditionInputBackground.layer.borderWidth = 2.5
        ConditionInputBackground.layer.cornerRadius = 20
        // ConditionImageView
        let conditionImage = UIImage(named: "condition")
        ConditionImageView.image = conditionImage
        // ConditionInputTextField
        ConditionInputTextField.text = "Select deliver time here"
        ConditionInputTextField.textColor = UIColor.lightGrayColor()

        // ToolBarButton
        Button1.title = "Drawer"
        Button2.title = "Mailbox"
        Button3.title = "Next"
        Button4.title = "Save"
        Button5.title = "Send"
    }

    
    
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        //將日期轉換成文字
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        ConditionInputTextField.text = dateFormatter.stringFromDate(sender.date)
        // 可以選擇的最早日期時間
        //        let fromDateTime = dateFormatter("2016-01-02 18:08")
        //        datePickerView.minimumDate = fromDateTime
    }
    
    
    @objc private func finishSelect(sender: AnyObject) {
        delivered_date = dateFormatter.dateFromString(ConditionInputTextField.text!)!
        
//        print(newPostcard)
        
        self.newPostcard[0].specific_date = delivered_date
        
        ConditionInputTextField.resignFirstResponder()
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
            ScrollView.setContentOffset(CGPointMake(0, 200), animated: true)
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





extension AddBondViewController {
    func next() { //打開deliver condition setup view
        
        let created_time = NSDate()
        print("postcard created time: \(created_time)")
        
        newPostcard.append(PostcardInDrawer(created_time:  created_time, title: currentTextOfTitle, context: currentTextOfContext, signature: currentTextOfSignature, image: imageData, specific_date: created_time))
        
        //        newPostcard = PostcardInDrawer(created_time: created_time, title: currentTextOfTitle, context: currentTextOfContext, signature: currentTextOfSignature, imageUrl: imageUrl, specific_date: created_time)
        let c = self.newPostcard.count
        print(c)
        
        DeliverConditionContentView.hidden = false
    }
    
    
    
    

    
    func savePostcard(postcardToSave: [PostcardInDrawer]) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Postcard", inManagedObjectContext: managedContext)
        
        let newPostcard = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        newPostcard.setValue(postcardToSave[0].sender, forKey: "sender")
        newPostcard.setValue(postcardToSave[0].created_time, forKey: "created_time")
        newPostcard.setValue(postcardToSave[0].title, forKey: "title")
        newPostcard.setValue(postcardToSave[0].context, forKey: "context")
        newPostcard.setValue(postcardToSave[0].signature, forKey: "signature")
        newPostcard.setValue(postcardToSave[0].image, forKey: "image")
        newPostcard.setValue(postcardToSave[0].specific_date, forKey: "specific_date")
//        print("image url is:")
//        print(postcardToSave[0].imageUrl)
        
        let c = self.newPostcard.count
        print(c)
//        print(self.newPostcard)
        
        do {
            try managedContext.save()
//            myPostcards.append(newPostcard) //好像也沒用到，在這裡存這幹嘛？底下的aa也記得要一起刪掉
        } catch {
            print("Error in saving newPostcard into core data")
        }
    }
    
    
    
    
    func sent(currentPostcard currentPostcard: [PostcardInDrawer]) { // sent postcard to server
        let postcardSentRef = firebaseDatabaseRef.shared.child("postcards").childByAutoId() // 在data base 並產生postcard's uid
        
        let postcardSentUid = postcardSentRef.key
        
        print("UID: \(postcardSentUid)")
        
        let imagePath = postcardSentUid //+ "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"// 該圖片存在firebase storage上的名稱
    
        let created_time = dateFormatter.stringFromDate(currentPostcard[0].created_time)
        let specific_date = dateFormatter.stringFromDate(currentPostcard[0].specific_date)
        
        let sendAPostcard: [String: AnyObject] =  [ "sender": currentPostcard[0].sender,
                                                                            "created_time": created_time,
                                                                            "title": currentPostcard[0].title,
                                                                            "context": currentPostcard[0].context,
                                                                            "signature": currentPostcard[0].signature,
                                                                            "image": imagePath, //記得image改成storage檔案的檔名
                                                                            "delivered_date": specific_date]
        
        postcardSentRef.setValue(sendAPostcard) //將postcard的資料新增進database
        
        firebaseStorageRef.shared.child(imagePath) //指定storage要存的相關資訊
        //在儲存到firebase storage前記得要去更改rule讓read,write = if true
        
        // 定義上傳資料的metadata，以便日後去判斷此筆資料是image/audio/video，並呼叫對應的方始來開啟該檔案
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        
        firebaseStorageRef.shared.child(imagePath).putData(imageData, metadata: metadata) { (metadata, error) in //將照片存入storage中
            
            if let error = error {
                print("Error upload image: \(error)")
                return
            } else {
                let downloadUrl = metadata!.downloadURL()!.absoluteString  // get downloadURL
                
                firebaseDatabaseRef.shared.child("postcards").child(postcardSentUid).updateChildValues(["image": downloadUrl]) // update postcard's image as its downloadURL
                
                print("update image downloadURL")   
            }
        }
        
        print("image stored")
    }

}



