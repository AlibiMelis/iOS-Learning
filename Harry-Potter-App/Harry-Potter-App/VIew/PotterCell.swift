//
//  PotterCellCollectionViewCell.swift
//  Harry-Potter-App
//
//  Created by Alibi on 28.02.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class PotterCell: UICollectionViewCell {
    
    
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterNameLbl: UILabel!
    
    var potter: Potters!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(potterrr: Potters) {
        
        self.potter = potterrr

        let url = URL(string: potter.imageURL)!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    self.characterImg.image = UIImage(data: data)
                }
            } catch  {
                //handle the error
            }
        }
        
        characterNameLbl.text = self.potter.name.capitalized
    }
}
