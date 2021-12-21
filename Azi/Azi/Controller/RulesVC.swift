//
//  RulesVC.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
    
    //MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.checkForInvites(inVC: self, completion: { (success, game, error) in
            if let game = game {
                self.performSegue(withIdentifier: "inviteFromRules", sender: game)
            }
        })
    }
    
    //MARK: - Preparing Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteFromRules" {
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
}
