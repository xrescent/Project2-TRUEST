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
    @IBAction func ConditionInputFieldClicked(sender: AnyObject) {
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
}







