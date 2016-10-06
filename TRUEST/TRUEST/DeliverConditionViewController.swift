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
    @IBOutlet weak var ConditionContextView: UIView!
    @IBOutlet weak var ConditionBackground: UILabel!
    @IBOutlet weak var ConditionInputField: UITextField!
    @IBAction func ConditionInputFieldClicked(sender: AnyObject) {
    }

    override func viewDidLoad() {
        self.viewDidLoad()
        
        setup()
    }
}


extension DeliverConditionViewController {
    private func setup() {
        
    }
}