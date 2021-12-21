//
//  CircularButton.swift
//  Scribe
//
//  Created by Alibi on 23/07/2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

@IBDesignable
class CircularButton: UIButton {

    @IBInspectable var cornerRadius = CGFloat() {
        didSet{
            setupView()
        }
    }
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        
        layer.cornerRadius = cornerRadius
    }
}
