//
//  MyTextField.swift
//  Addresslator
//
//  Created by Alibi on 23/01/2019.
//  Copyright © 2019 Alibi. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: 120.0 / 255.0, green: 120.0 / 255.0, blue: 120.0 / 255.0, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
}
