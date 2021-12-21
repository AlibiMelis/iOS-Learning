//
//  ViewController.swift
//  Color matching
//
//  Created by Alibi on 27.01.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameColorLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var inARowScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var labelForRow: UILabel!
    
    let colorArray = [UIColor.black, UIColor.blue, UIColor.brown, UIColor.green, UIColor.orange, UIColor.purple, UIColor.red, UIColor.yellow]
    let nameColorArray = ["black", "blue", "brown", "green", "orange", "purple", "red", "yellow"]
    
    var colorIndex: Int!
    var nameColorIndex: Int!
    var rowScore = 0
    var totalScore = 0
    
    
    func returnRandomNumber() -> Int {
        let random = Int(arc4random_uniform(UInt32(colorArray.count)))
        return random
    }
    func showNextQuestion() {
        colorIndex = returnRandomNumber()
        nameColorIndex = returnRandomNumber()
        
        colorLabel.text = nameColorArray[returnRandomNumber()]
        nameColorLabel.text = nameColorArray[nameColorIndex]
        colorLabel.textColor = colorArray[colorIndex]
        nameColorLabel.textColor = colorArray[returnRandomNumber()]
        
        clearButtons()
        toggleButtons(toggle: true)
    }
    func clearButtons() {
        yesButton.backgroundColor = UIColor.clear
        noButton.backgroundColor = UIColor.clear
    }
    func toggleButtons(toggle: Bool) {
        yesButton.isUserInteractionEnabled = toggle
        noButton.isUserInteractionEnabled = toggle
    }
    func addScore() {
        inARowScoreLabel.text = String(rowScore + 1)
        totalScoreLabel.text = String(totalScore + 1)
        rowScore += 1
        totalScore += 1
        if rowScore == 5 {
            labelForRow.text = "Ohh, it's getting warmer!"
        } else if rowScore == 10 {
            labelForRow.text = "Unstoppable!"
        } else if rowScore == 15 {
            labelForRow.text = "GODLIKE"
        }
    }
    func clearRowScore() {
        inARowScoreLabel.text = nil
        rowScore = 0
        labelForRow.text = nil
    }
    func clearTotalScore() {
        totalScoreLabel.text = nil
        totalScore = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextQuestion()
        clearRowScore()
        clearTotalScore()
        labelForRow.text = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func yesButtonPressed(_ sender: UIButton) {
        if colorIndex == nameColorIndex {
            sender.backgroundColor = UIColor.green
            addScore()
        } else {
            sender.backgroundColor = UIColor.red
            clearRowScore()
        }
        toggleButtons(toggle: false)
    }
    @IBAction func noButtonPressed(_ sender: UIButton) {
        if colorIndex == nameColorIndex {
            sender.backgroundColor = UIColor.red
            clearRowScore()
        } else {
            sender.backgroundColor = UIColor.green
            addScore()
        }
        toggleButtons(toggle: false)
    }
    @IBAction func nextButtonPressed() {
        showNextQuestion()
    }
    
    
}

