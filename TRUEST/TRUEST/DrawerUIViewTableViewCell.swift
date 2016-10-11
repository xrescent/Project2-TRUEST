//
//  DrawerUIViewTableViewCell.swift
//  TRUEST
//
//  Created by MichaelRevlis on 2016/10/5.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class DrawerUIViewTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentView: UIView!
    var cellBackground = UILabel(frame: CGRectMake(20, 20, 320, 80))
    var imageInSmall = UIImageView()
//    var smallImage = UIImage()
    var title = UILabel()
    var receivers = UILabel()
    private var titleImage = UIImageView()
    private var receiverImage = UIImageView()
    private var conditionImage = UIImageView()
    private var urgencyImage = UIImageView()
    var lastEditedLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
        
    }
    
}

extension DrawerUIViewTableViewCell {
    private func setup() {
        
        cellBackground.backgroundColor = UIColor.lightGrayColor()
        cellBackground.layer.borderColor = UIColor.greenColor().CGColor
        cellBackground.layer.borderWidth = 5.0
        cellBackground.layer.cornerRadius = cellBackground.frame.height / 2
        cellBackground.clipsToBounds = true
        
        title.frame = CGRectMake(122, 30, 100, 30)
        title.backgroundColor = UIColor.redColor()
        
        lastEditedLabel.frame = CGRectMake(20, 100, 320, 20)
        lastEditedLabel.backgroundColor = UIColor.whiteColor()
        lastEditedLabel.textAlignment = .Right
        
        titleImage.frame = CGRectMake(95, 32.5, 25, 25)
        titleImage.image = UIImage(named: "title")!//.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        titleImage.tintColor = UIColor.grayColor()
        
        receiverImage.frame = CGRectMake(95, 65, 25, 25)
        receiverImage.image = UIImage(named: "receiver")
        
        conditionImage.frame = CGRectMake(222, 35, 50, 50)
        conditionImage.image = UIImage(named: "condition")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        conditionImage.tintColor = UIColor.blueColor()
        
        let urgency = UIImage(named: "urgency")
        urgencyImage.frame = CGRect(center: CGPoint(x: 300, y: 60), size: CGSize(width: 50, height: 50))
//            CGRectMake(272, 35, 45, 45)
        urgencyImage.image = urgency
        urgencyImage.opaque = false
//        urgencyImage.backgroundColor = UIColor.clearColor()

        
        self.ContentView.addSubview(cellBackground)
        self.ContentView.addSubview(title)
        self.ContentView.addSubview(imageInSmall)
        self.ContentView.addSubview(lastEditedLabel)
        self.ContentView.addSubview(titleImage)
        self.ContentView.addSubview(receiverImage)
        self.ContentView.addSubview(conditionImage)
        self.ContentView.addSubview(urgencyImage)
    }
}

