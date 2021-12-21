//
//  FriendCell.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class FriendCell: UITableViewCell {
    //MARK: - Outlets  
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var nicknameLabel: UILabel!
    //MARK: - Functions
    
    func configureFriendCell(ofFriend friendUser: User) {
        
        self.nicknameLabel.text = friendUser.nickname
        if let image = MainVC.imageCache.object(forKey: friendUser.imageURL as NSString) {
            self.profileImage.image = image
        } else {
            if friendUser.imageURL == "default" {
                self.profileImage.image = UIImage(named: "avatar")
            } else {
                let ref = Storage.storage().reference(forURL: friendUser.imageURL)
                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("ALIBI: Couldn't download image from Firebase Storage")
                    } else {
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.profileImage.image = img
                                MainVC.imageCache.setObject(img, forKey: friendUser.imageURL as NSString)
                            }
                        }
                    }
                })
            }
        }
    }
}
