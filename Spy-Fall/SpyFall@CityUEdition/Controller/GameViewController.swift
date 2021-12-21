//
//  GameViewController.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var yourRoleIsLabel: UILabel!
    @IBOutlet weak var roleImage: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationRoleLabel: UILabel!
    @IBOutlet weak var nextPlayerButton: UIButton!

    
    
    
    var settings = [Int]()
    var players = [Players]()
    var location = Locations()
    var game = Games()
    var currentPlayerIndex = 0
    var showingRole = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainBg = UIImage(named: "mainbg")
        view.backgroundColor = UIColor(patternImage: mainBg!)
        
        creatingGame()
    }
    
    
    func creatingGame() {

        location.chooseRandomLocation()
        creatingPLayersDB()
        game.configureGame(settings: settings, players: players, location: location)
        for i in 0..<game.players.count {
            print(game.players[i].role)
        }
    }
    
    func creatingPLayersDB() {
        
        let names = ["Aizhigit", "Toto", "Aizhan", "Aigerim", "Alibi", "Dastan", "Zhandos", "Samat", "Kadyr"]
        for name in names {
            
            let player = Players(name: name)
            players.append(player)
        }
        
    }
    
    func configureUI() {
        
        if showingRole {
            
            roleImage.image = UIImage(named: game.players[currentPlayerIndex].role)
            roleLabel.text = game.players[currentPlayerIndex].role.capitalized

            if game.players[currentPlayerIndex].role == "spy" {
                locationLabel.text = "Guess the location!"
                locationRoleLabel.text = ""
                if currentPlayerIndex == game.players.count - 1 {
                    nextPlayerButton.setTitle("The game is on", for: .normal)
                } else {
                    nextPlayerButton.setTitle("Pass to next player", for: .normal)
                }
                showingRole = !showingRole
                currentPlayerIndex += 1
                
            } else {
                    
                locationLabel.text = "Location: \(game.location.name)"
                locationRoleLabel.text = "Location Role: \(game.players[currentPlayerIndex].locationRole)"
                if currentPlayerIndex == game.players.count - 1 {
                    nextPlayerButton.setTitle("The game is on", for: .normal)
                } else {
                    nextPlayerButton.setTitle("Pass to next player", for: .normal)
                }
                showingRole = !showingRole
                currentPlayerIndex += 1
            }
            
        } else {
            if currentPlayerIndex < game.players.count {
                yourRoleIsLabel.text = "\(game.players[currentPlayerIndex].name), you role is:"
                roleImage.image = UIImage()
                roleLabel.text = "???"
                locationLabel.text = "???"
                locationRoleLabel.text = "???"
                nextPlayerButton.setTitle("Check my role!", for: .normal)
                showingRole = !showingRole
            } else {
                print("The game is finished")
            }
            
        }
    }
    
    @IBAction func nextPlayerButtonPressed(_ sender: Any) {
        
        configureUI()
    }
    
        
    
    
    @IBAction func endGameButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
