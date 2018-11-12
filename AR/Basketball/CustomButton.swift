//
//  CustomButton.swift
//  AR
//
//  Created by hyerikim on 30/10/2018.
//  Copyright © 2018 hyerikim. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeButton()
    }
    
    func customizeButton () {
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}
