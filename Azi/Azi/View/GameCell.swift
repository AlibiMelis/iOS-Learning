//
//  GameCell.swift
//  Azi
//
//  Created by Alibi on 5/11/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet var tableNameLabel: UILabel!
    @IBOutlet var playersNumberLabel: UILabel!
    @IBOutlet var stakeLabel: UILabel!
    @IBOutlet var closedImage: UIImageView!
    
    //MARK: - Functions
    func configureGameCell(of game: Game) {
        self.tableNameLabel.text = game.tableName
        self.playersNumberLabel.text = "\(game.currentPlayersNum)/\(game.maxPlayers)"
        self.stakeLabel.text = "\(game.stake)"
        if game.closed == "none" {
            self.closedImage.image = UIImage(named: "unlocked")
        } else {
            self.closedImage.image = UIImage(named: "locked")
        }
    }
}
