//
//  JoinVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class JoinVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var privateView: UIView!
    @IBOutlet var passwordLabel: UILabel!
    
    //MARK: - Variables
    var games = [Game]()
    var password = "" {
        didSet {
            passwordLabel.text = password
        }
    }
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        
        downloadGames()
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromJoin", sender: game)
            }
        })
    }
    
    //MARK: - Prepating Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "toExistingGame":
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    DataService.ds.REF_CURRENT_USER.updateChildValues(["inGame": ["id": game.tableID,
                    "name": game.tableName]])
                    whereToSeat(inGame: game)
                }
            }
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        case "inviteFromJoin":
            if let gameVC = segue.destination as? GameViewController {
                if let game = sender as? Game {
                    gameVC.game = game
                    DataService.ds.REF_CURRENT_USER.updateChildValues(["inGame": ["id": game.tableID,
                    "name": game.tableName]])
                    whereToSeat(inGame: game)
                }
            }
        default: return
        }
    }
    
    //MARK: - Table View Data Source Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as? GameCell {

            cell.configureGameCell(of: games[indexPath.row])
            return cell
        } else {
            print("ALIBI: Couldn't configure cell")
            return GameCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.games[indexPath.row].currentPlayersNum == self.games[indexPath.row].maxPlayers {
            let fullAlert = UIAlertController(title: "Table is full", message: "There are not any empty seats for you in this game", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            fullAlert.addAction(okAction)
            present(fullAlert, animated: true, completion: nil)
        } else {
            if self.games[indexPath.row].closed == "none" {
                performSegue(withIdentifier: "toExistingGame", sender: self.games[indexPath.row])
            } else {
                privateView.isHidden = false
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if password != "" {
            password.removeLast(1)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        password = ""
        privateView.isHidden = true
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        password += "\(sender.tag)"
        
        if password.count == 4 {
            
            checkPassword(password, forGame: self.games[tableView.indexPathForSelectedRow!.row])
        }
    }
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        if password != "" {
            checkPassword(password, forGame: self.games[tableView.indexPathForSelectedRow!.row])
        } else {
            let enterPasswordAlert = UIAlertController(title: "Type password, please", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            enterPasswordAlert.addAction(okAction)
            self.present(enterPasswordAlert, animated: true, completion: nil)
        }
    }
    @IBAction func outsideTapped(_ sender: UITapGestureRecognizer) {
        password = ""
        privateView.isHidden = true
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
    }
    
    //MARK: - Functions
    func checkPassword(_ password: String, forGame game: Game) {
        privateView.isHidden = true
        if password == game.closed {
            performSegue(withIdentifier: "toExistingGame", sender: game)
        } else {
            let wrongPasswordAlert = UIAlertController(title: "Wrong password", message: nil, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.password = ""
                self.privateView.isHidden = false
            })
            wrongPasswordAlert.addAction(retryAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
            })
            wrongPasswordAlert.addAction(cancelAction)
            self.present(wrongPasswordAlert, animated: true, completion: nil)
        }
    }
    
    func downloadGames() {
        DataService.ds.REF_GAMES.observe(.value, with: { (snapshot) in
            
            self.games = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    if let gameData = snap.value as? Dictionary<String, AnyObject> {
                        let gameID = snap.key
                        let game = Game(gameID: gameID, gameData: gameData)
                        if !game.onGame {
                            self.games.append(game)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            
        })
    }
}
