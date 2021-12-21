//
//  MyView.swift
//  Addresslator
//
//  Created by Alibi on 23/01/2019.
//  Copyright © 2019 Alibi. All rights reserved.
//

import UIKit

class MyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: 120.0 / 255.0, green: 120.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
