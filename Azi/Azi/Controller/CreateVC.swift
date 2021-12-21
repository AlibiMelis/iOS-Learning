//
//  CreateVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class CreateVC: UIViewController, UITextFieldDelegate {
    //MARK: - Outlets
    @IBOutlet var stakeLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableNameTextField: UITextField!
    @IBOutlet var privateView: UIView!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var privateButton: UIButton!
    @IBOutlet var privateGameLabel: UILabel!
    
    //MARK: - Variables
    var stake: Int = 100 {
        didSet {
            stakeLabel.text = "\(stake)"
        }
    }
    var password = "" {
        didSet {
            passwordLabel.text = password
        }
    }
    var maxPlayers = 4
    var isPrivate = false
    
    //MARK: - View loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableNameTextField.delegate = self
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromCreate", sender: game)
            }
        })
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "toCreatedGame":
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    DataService.ds.REF_CURRENT_USER.updateChildValues(["inGame": ["id": game.tableID,
                                                                                  "name": game.tableName]])
                }
            }
        case "inviteFromCreate":
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    
                    DataService.ds.whereToSeat(inGame: game.tableID, completion: { (success, seat, error) in
                        DataService.ds.REF_GAMES.child(game.tableID).child("players").updateChildValues([currentUserUID: ["seat": seat,
                        "stack": 0]])
                        currentSeat = seat!
                        if error != nil {
                            print("ALIBI: Couldn't add player to game with error \(error.debugDescription)")
                        }
                    })
                }
            }
        default: return
        }
    }
    
    //MARK: - Actions
    @IBAction func createButtonPressed(_ sender: UIButton) {
        
        guard let tableName = tableNameTextField.text, tableNameTextField.text != "" else {
            let tableNameAlert = UIAlertController(title: "Table name missing", message: "Please enter the name of your table", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            tableNameAlert.addAction(okAction)
            self.present(tableNameAlert, animated: true, completion: nil)
            return
        }
        
        let privat: String = {
            if isPrivate {
                return password
            }
            return "none"
        }()
        
        let gameData = ["tableName": tableName,
                        "maxPlayers": segmentedControl.selectedSegmentIndex + 2,
                        "private": privat,
                        "stake": stake,
                        "onGame": false] as [String : AnyObject]
        currentSeat = 1
        let game = DataService.ds.createGame(gameData: gameData)
        performSegue(withIdentifier: "toCreatedGame", sender: game)
        password = ""
        tableNameTextField.text = ""
        segmentedControl.selectedSegmentIndex = 2
    }
    
    @IBAction func privateGameChecked(_ sender: UIButton) {
        
        if isPrivate {
            password = ""
            privateButton.setImage(UIImage(named: "unchecked"), for: .normal)
            privateGameLabel.text = "Private game"
            isPrivate = false
        } else {
            privateView.isHidden = false
            privateButton.setImage(UIImage(named: "checked"), for: .normal)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        
        password = ""
        isPrivate = false
        privateView.isHidden = true
        privateButton.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        password += "\(sender.tag)"
        
        if password.count == 4 {
            
            isPrivate = true
            privateView.isHidden = true
            privateGameLabel.text = "Password: \(password)"
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if password != "" {
            password.removeLast(1)
        }
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        if password != "" {
            isPrivate = true
            privateView.isHidden = true
            privateGameLabel.text = "Password: \(password)"
        }
    }
    @IBAction func outsideTapped(_ sender: UITapGestureRecognizer) {
        password = ""
        isPrivate = false
        privateView.isHidden = true
        privateButton.setImage(UIImage(named: "unchecked"), for: .normal)
    }
    
    @IBAction func stakeSlider(_ sender: UISlider) {
        switch sender.value {
        case 0..<6.667:
            stake = 100
        case 6.667..<13.333:
            stake = 250
        case 13.333..<20:
            stake = 500
        case 20..<26.667:
            stake = 1000
        case 26.667..<33.333:
            stake = 2500
        case 33.333..<40:
            stake = 5000
        case 40..<46.667:
            stake = 10000
        case 46.667..<53.333:
            stake = 25000
        case 53.333..<60:
            stake = 50000
        case 60..<66.667:
            stake = 100000
        case 66.667..<73.333:
            stake = 250000
        case 73.333..<80:
            stake = 500000
        case 80..<86.667:
            stake = 1000000
        case 86.667..<93.333:
            stake = 2500000
        case 93.333..<100:
            stake = 5000000
        case 100:
            stake = 10000000
        default:
            break
        }
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
