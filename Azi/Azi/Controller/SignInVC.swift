//
//  SignInVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    //MARK: - View loaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("ALIBI: ID found in KeyChain")
            performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("ALIBI: User authenticated with Firebase through Email")
                    if let user = user {
                        let userData = ["email": user.user.email!] as [String: AnyObject]
                        self.finishSignIn(id: user.user.uid, userData: userData)
                    }
                } else {
                    let alert = UIAlertController(title: "Wrong email or password", message: "You typed in wrong password or email. Please, try again", preferredStyle: .alert)
                    let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                    alert.addAction(tryAgainAction)
                    self.present(alert, animated: true, completion: nil)
                    print("ALIBI: Couldn't authenticate with Firebase through Email")
                }
            })
        }
    }
    
    //Register
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Functions
    func finishSignIn(id: String, userData: Dictionary<String, AnyObject>) {
        DataService.ds.createDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ALIBI: Data saved to KeyChain \(keychainResult)")
        performSegue(withIdentifier: "toMain", sender: nil)
    }
}
