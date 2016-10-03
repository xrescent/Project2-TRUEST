//
//  AddBondViewController.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/1.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

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
    private let imagePicker = UIImagePickerController()

    
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
        guard let concelImage = UIImage(named: "icon_close_button") else {fatalError()}
        ConcelPress.setImage(concelImage, forState: .Normal)
        ConcelPress.addTarget(self, action: #selector(AddBondViewController.AbortSelectedImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
}


extension AddBondViewController{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            PostcardImage.contentMode = .ScaleToFill
            PostcardImage.image = pickedImage
            self.pickedImage = pickedImage as UIImage
        }
        
        AddPhotoDescription.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension AddBondViewController {
    @objc private func AbortSelectedImage(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
}