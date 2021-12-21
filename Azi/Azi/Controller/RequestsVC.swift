//
//  RequestsVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import Firebase

class RequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //MARK: - Variables
    var segment = 0
    var incomingRequests = [User]()
    var outgoingRequests = [User]()
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 65
        
        segmentedControl.addTarget(self, action: #selector(requestTypeChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        downloadRequestsData()
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromRequests", sender: game)
            }
        })
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteFromRequests" {
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
        switch segment {
        case 0:
            return incomingRequests.count
        case 1:
            return outgoingRequests.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segment {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as? IncomingRequestCell {
                
                cell.acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
                cell.rejectButton.addTarget(self, action: #selector(rejectRequest), for: .touchUpInside)
                cell.acceptButton.tag = indexPath.row
                cell.rejectButton.tag = indexPath.row
                cell.configureIncomingCell(ofRequest: incomingRequests[indexPath.row])
                return cell
            } else {
                return IncomingRequestCell()
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as? OutgoingRequestCell {
                
                cell.dismissButton.addTarget(self, action: #selector(dismissRequest), for: .touchUpInside)
                cell.dismissButton.tag = indexPath.row
                cell.configureOutgoingCell(ofRequest: outgoingRequests[indexPath.row])
                return cell
            } else {
                return OutgoingRequestCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    //MARK: - Functions
    func downloadRequestsData() {
        DataService.ds.REF_CURRENT_USER.observe(.value, with: {(snapshot) in
            
            if let userData = snapshot.value as? [String: AnyObject] {
                if let requestsFrom = userData["requestsFrom"] as? Dictionary<String, Bool> {
                    for request in requestsFrom.keys {
                        DataService.ds.REF_USERS.child(request).observe(.value, with: { (fromSnapshot) in
                            
                            self.incomingRequests = []
                            if let userData = fromSnapshot.value as? [String: AnyObject] {
                                let user = User(friendKey: request, friendData: userData)
                                self.incomingRequests.append(user)
                            }
                            self.incomingRequests.sort()
                            self.tableView.reloadData()
                        })
                    }
                }
                if let requestsTo = userData["requestsTo"] as? Dictionary<String, Bool> {
                    for request in requestsTo.keys {
                        DataService.ds.REF_USERS.child(request).observe(.value, with: { (fromSnapshot) in
                            
                            self.outgoingRequests = []
                            if let userData = fromSnapshot.value as? [String: AnyObject] {
                                let user = User(friendKey: request, friendData: userData)
                                self.outgoingRequests.append(user)
                            }
                            self.outgoingRequests.sort()
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        })
    }
    
    @objc func requestTypeChanged(_ segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            segment = 0
        case 1:
            segment = 1
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    @objc func acceptRequest(_ sender: UIButton) {
        
        let row = sender.tag
        DataService.ds.REF_USERS.child(incomingRequests[row].userKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            
            let acceptAlert = UIAlertController(title: "Accept friend request?", message: "Do you want to accept friend request from \(nickname)?", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: {(action) in
                DataService.ds.REF_CURRENT_USER.child("friends").updateChildValues([self.incomingRequests[row].userKey: true])
                DataService.ds.REF_USERS.child(self.incomingRequests[row].userKey).child("friends").updateChildValues([currentUserUID: true])
                DataService.ds.REF_CURRENT_USER.child("requestsFrom").child(self.incomingRequests[row].userKey).removeValue()
                DataService.ds.REF_USERS.child(self.incomingRequests[row].userKey).child("requestsTo").child(currentUserUID).removeValue()
            })
            acceptAlert.addAction(acceptAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            acceptAlert.addAction(cancelAction)
            self.present(acceptAlert, animated: true, completion: nil)
        })
        
        
    }
    
    @objc func rejectRequest(_ sender: UIButton) {
        let row = sender.tag
        
        DataService.ds.REF_USERS.child(incomingRequests[row].userKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            
            let rejectAlert = UIAlertController(title: "Reject friend request?", message: "Do you want to reject friend request from \(nickname)?", preferredStyle: .alert)
            let rejectAction = UIAlertAction(title: "Reject", style: .destructive, handler: {(action) in
                DataService.ds.REF_CURRENT_USER.child("requestsFrom").child(self.incomingRequests[row].userKey).removeValue()
                DataService.ds.REF_USERS.child(self.incomingRequests[row].userKey).child("requestsTo").child(currentUserUID).removeValue()
            })
            rejectAlert.addAction(rejectAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            rejectAlert.addAction(cancelAction)
            self.present(rejectAlert, animated: true, completion: nil)
        })
    }
    
    @objc func dismissRequest(_ sender: UIButton) {
        let row = sender.tag
        
        DataService.ds.REF_USERS.child(outgoingRequests[row].userKey).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
            
            let dismissAlert = UIAlertController(title: nil, message: "Are you sure you want to cancel your friend request to \(nickname)?", preferredStyle: .alert)
            let removeAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                DataService.ds.REF_CURRENT_USER.child("requestsTo").child(self.outgoingRequests[row].userKey).removeValue()
                DataService.ds.REF_USERS.child(self.outgoingRequests[row].userKey).child("requestsFrom").child(currentUserUID).removeValue()
            })
            dismissAlert.addAction(removeAction)
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            dismissAlert.addAction(cancelAction)
            self.present(dismissAlert, animated: true, completion: nil)
        })
        
    }
}
