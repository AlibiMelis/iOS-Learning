//
//  RegisterVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class RegisterVC: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    //MARK: - Outlets
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    //MARK: - Variables
    var imageSelected = false
    
    //MARK: - View loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        //Creating new user
        if let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "", passwordTextField.text == passwordConfirmTextField.text {
            
            var nickname = nicknameTextField.text ?? ""
            if nickname == "" {
                nickname = emailTextField.text!
            }
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {( user, error ) in
                
                if error != nil {
                    print("ALIBI: Unable to create user \(error.debugDescription)")
                    let passwordAlert = UIAlertController(title: "Password is too short", message: "Password must contain at least 6 characters", preferredStyle: .alert)
                    let okAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
                    passwordAlert.addAction(okAction)
                    self.present(passwordAlert, animated: true, completion: nil)
                } else {
                    print("ALIBI: User created successfully")
                    if self.imageSelected {
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
                                    if let user = user {
                                        let userData = ["email": user.user.email!,
                                                        "nickname": nickname,
                                                        "money": 4999,
                                                        "gold": 25,
                                                        "imageURL": downloadURL] as [String : AnyObject]
                                        self.finishReg(id: user.user.uid, userData: userData)
                                    }
                                }
                            }
                        }
                    } else {
                        if let user = user {
                            let userData = ["email": user.user.email!,
                                            "nickname": nickname,
                                            "money": 4999,
                                            "gold": 25,
                                            "imageURL": "default"] as [String : AnyObject]
                            self.finishReg(id: user.user.uid, userData: userData)
                        }
                    }
                }
            })
        } else {
            let alert = UIAlertController(title: "Input data validation", message: "Please, check if you entered your email and password correctly", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        let imagePicker = UIImagePickerController()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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
    func finishReg(id: String, userData: Dictionary<String, AnyObject>) {
        DataService.ds.createDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ALIBI: Data saved to Keychain \(keychainResult)")
        performSegue(withIdentifier: "toMainAfterReg", sender: nil)
    }
    
    //MARK: - ImagePicker Protocol
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        profileImageView.image = imagePicked
        imageSelected = true
        dismiss(animated: true, completion: nil)
    }
}
