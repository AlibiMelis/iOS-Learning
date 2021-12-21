//
//  InviteFriendCell.swift
//  Azi
//
//  Created by Alibi on 5/15/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import PureLayout
import Firebase

class InviteFriendCell: UITableViewCell {
    //MARK: - Properties
    
    private var profileImage = UIImageView()
    
    private var nickname = UILabel() 
    
    //MARK: - Initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(nickname)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureInviteFriendCell(ofFriend friendUser: User) {
        let inset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        profileImage.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        profileImage.autoPinEdgesToSuperviewEdges(with: inset, excludingEdge: .trailing)
        profileImage.autoConstrainAttribute(.width, to: .height, of: profileImage)
        
        nickname.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        nickname.autoPinEdgesToSuperviewEdges(with: inset, excludingEdge: .leading)
        nickname.autoPinEdge(.leading, to: .trailing, of: profileImage, withOffset: 12)
        
        self.nickname.text = friendUser.nickname
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
