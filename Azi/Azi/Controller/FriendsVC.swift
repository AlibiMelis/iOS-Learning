//
//  FriendsVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noFriendsLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var editButton: UIButton!
    
    //MARK: - Variables
    var friends = [User]()
    var searchResult = [User]()
    var inSearchMode = false
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        searchBar.delegate = self
        downloadFriends()
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromFriends", sender: game)
            }
        })
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteFromFriends" {
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
    
    //MARK: - Table View Data Source Protocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return searchResult.count
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell {
            if inSearchMode {
                cell.configureFriendCell(ofFriend: searchResult[indexPath.row])
                checkIfFriends(in: cell, row: indexPath.row)
            } else {
                cell.configureFriendCell(ofFriend: friends[indexPath.row])
                cell.addButton.isHidden = true
            }
            return cell
        } else {
            return FriendCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.ds.REF_USERS.child(friends[indexPath.row].userKey).observeSingleEvent(of: .value, with: {(snapshot) in

                let value = snapshot.value as? NSDictionary
                let nickname = value?["nickname"] as? String ?? ""

                let deleteAlert = UIAlertController(title: "Remove \(nickname) from friends?", message: "Are you sure you want to remove \(nickname) from your friends list?", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                deleteAlert.addAction(cancelAction)
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                    DataService.ds.REF_USERS.child(self.friends[indexPath.row].userKey).child("requestsTo").updateChildValues([currentUserUID: true])
                    DataService.ds.REF_CURRENT_USER.child("requestsFrom").updateChildValues([self.friends[indexPath.row].userKey: true])
                    DataService.ds.REF_USERS.child(self.friends[indexPath.row].userKey).child("friends").child(currentUserUID).removeValue()
                    DataService.ds.REF_CURRENT_USER.child("friends").child(self.friends[indexPath.row].userKey).removeValue()
                    })
                deleteAlert.addAction(removeAction)
                self.present(deleteAlert, animated: true, completion: nil)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? FriendCell
        if inSearchMode {
            DataService.ds.REF_CURRENT_USER.observeSingleEvent(of: .value, with: {(snapshot) in
                if !snapshot.childSnapshot(forPath: "friends").hasChild(self.searchResult[indexPath.row].userKey) {
                    
                    if !snapshot.childSnapshot(forPath: "requestsTo").hasChild(self.searchResult[indexPath.row].userKey) {
                        
                        DataService.ds.REF_CURRENT_USER.child("requestsTo").updateChildValues([self.searchResult[indexPath.row].userKey: true])
                        DataService.ds.REF_USERS.child(self.searchResult[indexPath.row].userKey).child("requestsFrom").updateChildValues([currentUserUID: true])
                        cell?.addButton.setImage(UIImage(named: "dismiss"), for: .normal)
                    } else {
                        let removeAlert = UIAlertController(title: nil, message: "Are you sure you want to cancel your friend request?", preferredStyle: .alert)
                        let removeAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                            DataService.ds.REF_USERS.child(self.searchResult[indexPath.row].userKey).child("requestsFrom").child(currentUserUID).removeValue()
                            DataService.ds.REF_CURRENT_USER.child("requestsTo").child(self.searchResult[indexPath.row].userKey).removeValue()
                            cell?.addButton.setImage(UIImage(named: "add"), for: .normal)
                        })
                        removeAlert.addAction(removeAction)
                        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                        removeAlert.addAction(cancelAction)
                        self.present(removeAlert, animated: true, completion: nil)
                    }
                }
            })
        }
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
    
    //MARK: - Actions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "", searchBar.text != nil {
            print("ALIBI: Search click works")
            inSearchMode = true
            self.searchResult.removeAll()
            searchFriends()
            view.endEditing(true)
            editButton.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        inSearchMode = false
        tableView.reloadData()
        editButton.isHidden = false
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if !tableView.isEditing {
            tableView.setEditing(true, animated: true)
            editButton.setTitle("Done", for: .normal)
        } else {
            tableView.setEditing(false, animated: true)
            editButton.setTitle("Edit", for: .normal)
        }
    }

    @IBAction func requestsButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toRequests", sender: nil)
    }
    
    //MARK: - Functions
    
    func checkIfFriends(in cell: FriendCell, row: Int) {
        DataService.ds.REF_CURRENT_USER.child("friends").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(self.searchResult[row].userKey) {
                cell.addButton.isHidden = true
            } else {
                cell.addButton.isHidden = false
            }
        })
        DataService.ds.REF_CURRENT_USER.child("requestsTo").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(self.searchResult[row].userKey) {
                cell.addButton.setImage(UIImage(named: "dismiss"), for: .normal)
            }
        })
    }
    
    func searchFriends() {
        DataService.ds.REF_USERS.observe(.value, with: {(snapshot) in
            self.searchResult = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    let searchUserKey = snap.key
                    if let searchUserData = snap.value as? [String: AnyObject] {
                        let searchUser = User(friendKey: searchUserKey, friendData: searchUserData)
                        let search = self.searchBar.text ?? ""
                        if searchUser.nickname.contains(search) {
                            self.searchResult.append(searchUser)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.noFriendsLabel.isHidden = true
            
        })
    }
    
    func downloadFriends() {
        DataService.ds.REF_CURRENT_USER.child("friends").observe(.value, with: {(snapshot) in
            
            self.friends = []
            if let friends = snapshot.value as? Dictionary<String, Bool> {
                for friend in friends.keys {
                    DataService.ds.REF_USERS.child(friend).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let friendData = snapshot.value as? [String: AnyObject] {
                            let friendUser = User(friendKey: friend, friendData: friendData)
                            self.friends.append(friendUser)
                        }
                        self.friends.sort()
                        self.tableView.reloadData()
                    })
                    
                }
                self.tableView.isHidden = false
                self.noFriendsLabel.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.noFriendsLabel.isHidden = false
            }
        })
    }
}
