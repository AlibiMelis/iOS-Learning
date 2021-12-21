//
//  MainVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MainVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
    
    //MARK: -
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromMain", sender: game)
            }
        })
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "inviteFromMain" :
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    DataService.ds.REF_CURRENT_USER.updateChildValues(["inGame": ["id": game.tableID,
                                                                                  "name": game.tableName]])
                    whereToSeat(inGame: game)
                }
            }
        default: navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toFriends", sender: nil)
    }
    
    @IBAction func rulesButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRules", sender: nil)
    }

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        let signOutAlert = UIAlertController(title: "Sign Out?", message: "Do you really want to sign out?", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        signOutAlert.addAction(signOutAction)
        signOutAlert.addAction(cancelAction)
        present(signOutAlert, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func configureSelfView() {
        
        DataService.ds.REF_CURRENT_USER.observe(.value, with: { (snapshot) in
            if let userData = snapshot.value as? [String: AnyObject] {
                let userKey = snapshot.key
                let user = User(userKey: userKey, userData: userData)
                
                self.navigationItem.title = user.nickname
                self.moneyLabel.text = self.numberFormatter.string(from: NSNumber(value: user.money))
                self.goldLabel.text = self.numberFormatter.string(from: NSNumber(value: user.gold))
                
                if let image = MainVC.imageCache.object(forKey: user.imageURL as NSString) {
                    self.profileImageView.image = image
                } else {
                    if user.imageURL == "default" {
                        self.profileImageView.image = UIImage(named: "avatar")
                    } else {
                        let ref = Storage.storage().reference(forURL: user.imageURL)
                        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("ALIBI: Couldn't download image from Firebase Storage")
                            } else {
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.profileImageView.image = img
                                        MainVC.imageCache.setObject(img, forKey: user.imageURL as NSString)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    func signOut() {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ALIBI: Data removed from KeyChain \(keychainResult)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
