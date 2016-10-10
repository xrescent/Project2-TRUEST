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
    private var titleImage = UIImage()
    private var receiverImage = UIImage()
    private var conditionImage = UIImage()
    private var urgencyImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
        
    }
    
}

extension DrawerUIViewTableViewCell {
    private func setup() {
        
        cellBackground.backgroundColor = UIColor.grayColor()
        cellBackground.layer.borderColor = UIColor.greenColor().CGColor
        cellBackground.layer.borderWidth = 5.0
        
        title.frame = CGRectMake(100, 30, 100, 30)
        title.backgroundColor = UIColor.redColor()
        
//        imageInSmall.frame = CGRectMake(35, 35, 50, 50)
//        imageInSmall.image = smallImage
//        imageInSmall.contentMode = .ScaleAspectFill
//        imageInSmall.contentMode = .Center
//        imageInSmall.alignmentRectForFrame(CGRectMake(35, 35, 50, 50))

        self.ContentView.addSubview(cellBackground)
        self.ContentView.addSubview(title)
        self.ContentView.addSubview(imageInSmall)
    }
}

