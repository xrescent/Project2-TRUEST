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
    private var cellBackground: UILabel!
    private var imageInSmall: UIImageView!
    private var title: UILabel!
    private var receivers: UILabel!
    private var titleImage: UIImage!
    private var receiverImage: UIImage!
    private var conditionImage: UIImage!
    private var urgencyImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
        
    }
    
}

extension DrawerUIViewTableViewCell {
    private func setup() {
        
        cellBackground.backgroundColor = UIColor.grayColor()
        
        self.ContentView.addSubview(cellBackground)
    }
}
