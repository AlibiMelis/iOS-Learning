//
//  myButton.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class myButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1.0
        //layer.borderColor = UIColor.white as! CGColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        backgroundColor = UIColor.clear
    }
}
