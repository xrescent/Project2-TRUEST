////
////  DeliverConditionViewController.swift
////  TRUEST
////
////  Created by MichaelRevlis on 2016/10/6.
////  Copyright © 2016年 MichaelRevlis. All rights reserved.
////
//
//import UIKit
//import CoreData
//import Firebase
//import FirebaseDatabase
//
//class DeliverConditionViewController: UIViewController {
//    
//    @IBOutlet weak var ContentView: UIView!
//    @IBOutlet weak var PostcardImageView: UIImageView!
//    @IBOutlet weak var ConditionImageView: UIImageView!
//    @IBOutlet weak var LabelForShadow: UILabel!
//    @IBOutlet weak var ConditionContextView: UIView!
//    @IBOutlet weak var ConditionBackground: UILabel!
//    @IBOutlet weak var ConditionInputField: UITextField!
//    
//    @IBOutlet weak var MainButton: UIBarButtonItem!
//    @IBOutlet weak var SettingButton: UIBarButtonItem!
//    
//    var newPostcard: [PostcardInDrawer] = []
////    var newPostcard: PostcardInDrawer
//    var imageData = NSData()
//    private var dateFormatter = NSDateFormatter()
//    private var delivered_date = NSDate()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setup()
//        
//    }
//}
//
//
//extension DeliverConditionViewController {
//    private func setup() {
//        
//        LabelForShadow.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        LabelForShadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
//        LabelForShadow.layer.shadowOpacity = 1.0
//        LabelForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        
//        ConditionBackground.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//        ConditionBackground.layer.borderColor = UIColor.blackColor().CGColor
//        ConditionBackground.layer.borderWidth = 2.5
//        ConditionBackground.layer.cornerRadius = 20
//        
//        let conditionImage = UIImage(named: "condition")
//        ConditionImageView.image = conditionImage
//        
//        ConditionInputField.text = "Select deliver time here"
//        ConditionInputField.textColor = UIColor.lightGrayColor()
//        
//    }
//    
//    
//    @IBAction func ConditionInputFieldClicked(sender: UITextField) {
//        ConditionInputField.text = ""
//        
//        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
//        
//        let datePickerView = UIDatePicker(frame: CGRectMake(0, 30, 0, 0))
//        //        datePickerView.backgroundColor = UIColor.whiteColor()
//        
//        
//        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 30))
//        doneButton.setTitle("Done", forState: UIControlState.Normal)
//        doneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
//        
//        inputView.addSubview(datePickerView)
//        inputView.addSubview(doneButton)
//        
//        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
//        
//        datePickerView.minuteInterval = 30  //設定每15分鐘為一個間隔
//        
//        sender.inputView = inputView
//        
//        datePickerView.addTarget(self, action: #selector(DeliverConditionViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        
//        doneButton.addTarget(self, action: #selector(DeliverConditionViewController.finishSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//    }
//
//    
//    @objc private func datePickerValueChanged(sender: UIDatePicker) {
//        //將日期轉換成文字
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        
//        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
//        
//        ConditionInputField.text = dateFormatter.stringFromDate(sender.date)
//        // 可以選擇的最早日期時間
////        let fromDateTime = dateFormatter("2016-01-02 18:08")
////        datePickerView.minimumDate = fromDateTime
//    }
//    
//    
//    @objc private func finishSelect(sender: AnyObject) {
//        delivered_date = dateFormatter.dateFromString(ConditionInputField.text!)!
//        
//        print(newPostcard)
//        
//        self.newPostcard[0].specific_date = delivered_date
//        
//        ConditionInputField.resignFirstResponder()
//    }
//    
//    
//    
//    func sent(currentPostcard currentPostcard: [PostcardInDrawer]) { // sent postcard to server
//        let postcardSentRef = firebaseDatabaseRef.shared.child("postcards").childByAutoId() // 在data base 並產生postcard's uid
//        
//        let postcardSentUid = postcardSentRef.key
//        
//        let imagePath = postcardSentUid + "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"// 該圖片存在firebase storage上的名稱
//        
//        let sendAPostcard: [String: AnyObject] =  [ "sender": currentPostcard[0].sender,
//                                                                            "created_time": currentPostcard[0].created_time,
//                                                                            "title": currentPostcard[0].title,
//                                                                            "context": currentPostcard[0].context,
//                                                                            "signature": currentPostcard[0].signature,
//                                                                            "image": imagePath, //記得image改成storage檔案的檔名
//                                                                            "delivered_date": currentPostcard[0].specific_date]
//        
//        postcardSentRef.setValue(sendAPostcard) //將postcard的資料新增進database
//        
//        firebaseStorageRef.shared.child(imagePath) //指定strage要存的相關資訊
//        //在儲存到firebase storage前記得要去更改rule讓read,write = if true
//        
//        // 定義上傳資料的metadata，以便日後去判斷此筆資料是image/audio/video，並呼叫對應的方始來開啟該檔案
//        let metadata = FIRStorageMetadata()
//        metadata.contentType = "image/jpg"
//        
//        firebaseStorageRef.shared.putData(imageData, metadata: metadata) { (metadata, error) in //將照片存入storage中
//            
//            if let error = error {
//                print("Error upload image: \(error)")
//                return
//            }
//        }
//        
//        print("UID: \(postcardSentUid)")
//
//    }
//    
//    
//    
//    
//    @IBAction func SavePressed(sender: AnyObject) {
//        savePostcard(newPostcard)
//    }
//    
//    @IBAction func SendPressed(sender: AnyObject) {
//        sent(currentPostcard: newPostcard)
//    }
//    
//    @IBAction func FinishDateSelect(sender: AnyObject) {
//        delivered_date = dateFormatter.dateFromString(ConditionInputField.text!)!
//        
//        self.newPostcard[0].specific_date = delivered_date
//        
//        ConditionInputField.resignFirstResponder()
//        //有傳資料但是沒有收datepicker
//    }
//    
//}
//
//
//
//
//
//
//
