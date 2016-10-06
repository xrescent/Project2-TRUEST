//
//  DeliverConditionViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/6.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class DeliverConditionViewController: UIViewController {
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var PostcardImageView: UIImageView!
    @IBOutlet weak var ConditionImageView: UIImageView!
    @IBOutlet weak var LabelForShadow: UILabel!
    @IBOutlet weak var LabelForRadius: UILabel!
    @IBOutlet weak var ConditionContextView: UIView!
    @IBOutlet weak var ConditionBackground: UILabel!
    @IBOutlet weak var ConditionInputField: UITextField!
    @IBAction func ConditionInputFieldClicked(sender: UITextField) {
        ConditionInputField.text = ""
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        
        let datePickerView = UIDatePicker(frame: CGRectMake(0, 30, 0, 0))//
        datePickerView.backgroundColor = UIColor.whiteColor()
        
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 30))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        inputView.addSubview(datePickerView)
        inputView.addSubview(doneButton)
        
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        
        datePickerView.minuteInterval = 30  //設定每15分鐘為一個間隔
        
        sender.inputView = inputView
        
        datePickerView.addTarget(self, action: #selector(DeliverConditionViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        doneButton.addTarget(self, action: #selector(DeliverConditionViewController.finishSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}


extension DeliverConditionViewController {
    private func setup() {
//        LabelForRadius.layer.cornerRadius =
//        LabelForShadow.layer.masksToBounds = true
//        LabelForShadow.layer.shadowPath = UIBezierPath(roundedRect: 0, cornerRadius: 0)
        LabelForShadow.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        LabelForShadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        LabelForShadow.layer.shadowOpacity = 1.0
        LabelForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        ConditionBackground.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        ConditionBackground.layer.borderColor = UIColor.blackColor().CGColor
        ConditionBackground.layer.borderWidth = 2.5
        ConditionBackground.layer.cornerRadius = 20
        
        let conditionImage = UIImage(named: "condition")
        ConditionImageView.image = conditionImage
        
        ConditionInputField.text = "Select deliver time here"
        ConditionInputField.textColor = UIColor.lightGrayColor()
        
    }
    
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        //將日期轉換成文字
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        
        ConditionInputField.text = dateFormatter.stringFromDate(sender.date)
        // 可以選擇的最早日期時間
//        let fromDateTime = dateFormatter("2016-01-02 18:08")
//        datePickerView.minimumDate = fromDateTime
    }
    
    
    @objc private func finishSelect(sender: AnyObject) {
        ConditionInputField.resignFirstResponder()
    }
    
}







