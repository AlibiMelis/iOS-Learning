//
//  SettingsVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Outlets
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    //MARK: - Variables
    var imageChanged = false
    var nickname = ""
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        
        nickname = nicknameTextField.text!
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromSettings", sender: game)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if nicknameTextField.text != "" {
            if nicknameTextField.text != nickname {
                DataService.ds.REF_CURRENT_USER.updateChildValues(["nickname": nicknameTextField.text!])
            }
        } else {
            DataService.ds.REF_CURRENT_USER.updateChildValues(["nickname": emailLabel.text!])
        }
        
        if imageChanged {
            if let imgData = self.profileImageView.image!.jpegData(compressionQuality: 0.2) {
                
                let imageUID = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.REF_USER_IMAGES.child(imageUID).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("ALIBI: Couldn't upload image to Firebase Storage. Error \(error.debugDescription)")
                    } else {
                        print("ALIBI: Successfully uploaded image to Firebase Storage")
                        let downloadURL = "\(STORAGE_BASE)\(metadata?.path! ?? "")"
                        self.deleteImage()
                        DataService.ds.REF_CURRENT_USER.updateChildValues(["imageURL": downloadURL])
                    }
                }
            }
        }
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteFromSettings" {
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    DataService.ds.REF_CURRENT_USER.updateChildValues(["inGame": ["id": game.tableID,
                                                                                  "name": game.tableName]])
                    whereToSeat(inGame: game)
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        let alertController = UIAlertController(title: "Do you want to change your profile image?", message: nil, preferredStyle: .actionSheet)
        
        //Configuring alert view to choose imagePicker type
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            }
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(libraryAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.profileImageView.image = UIImage(named: "avatar")
            self.deleteImage()
            DataService.ds.REF_CURRENT_USER.updateChildValues(["imageURL": "default"])
        })
        DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let imageURL = value["imageURL"] as? String
            if imageURL != "default" {
                alertController.addAction(deleteAction)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Functions
    func deleteImage() {
        DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let imageURL = value["imageURL"] as! String
            let imageLink = imageURL.replacingOccurrences(of: "gs://azi-online2020.appspot.com/user_images/", with: "")
            DataService.ds.REF_USER_IMAGES.child(imageLink).delete(completion: nil)
            MainVC.imageCache.removeObject(forKey: imageURL as NSString)
        })
    }
    
    func configureSelfView() {
        
        DataService.ds.REF_CURRENT_USER.observe(.value, with: { (snapshot) in
            if let userData = snapshot.value as? [String: AnyObject] {
                let userKey = snapshot.key
                let user = User(userKey: userKey, userData: userData)
                
                self.nicknameTextField.text = user.nickname
                self.emailLabel.text = user.email
                
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
    
    //MARK: - Image Picker Protocol
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        profileImageView.image = imagePicked
        imageChanged = true
        dismiss(animated: true, completion: nil)
    }
}
