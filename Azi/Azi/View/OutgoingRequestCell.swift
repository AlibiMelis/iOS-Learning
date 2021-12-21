//
//  OutgoingRequestCell.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class OutgoingRequestCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var dismissButton: UIButton!
    
    //MARK: - Functions
    
    func configureOutgoingCell(ofRequest requestedUser: User) {
        
        self.nicknameLabel.text = requestedUser.nickname
        if let image = MainVC.imageCache.object(forKey: requestedUser.imageURL as NSString) {
            self.profileImage.image = image
        } else {
            if requestedUser.imageURL == "default" {
                self.profileImage.image = UIImage(named: "avatar")
            } else {
                let ref = Storage.storage().reference(forURL: requestedUser.imageURL)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ALIBI: Couldn't download image from Firebase Storage")
                    } else {
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                                MainVC.imageCache.setObject(img, forKey: requestedUser.imageURL as NSString)
                            }
                        }
                    }
                })
            }
        }
    }
}
