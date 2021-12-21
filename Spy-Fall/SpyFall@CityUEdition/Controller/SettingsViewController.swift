//
//  SettingsViewController.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!

    var settings = [2, 1, 0, 0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let mainBg = UIImage(named: "mainbg")
        view.backgroundColor = UIColor(patternImage: mainBg!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return settings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1:
            return settings[0] / 2
        case 2:
            return settings[1] + 1
        case 3:
            return settings[1] + 1
        default:
            return 9
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0...1:
            return "\(row + 1)"
        default:
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            settings[0] = row + 1
        case 1:
            settings[1] = row + 1
        case 2:
            settings[2] = row
        case 3:
            settings[3] = row
        default:
            break
        }
        pickerView.reloadAllComponents()
    }
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "StartGame", sender: settings)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame" {
            if let gameVC = segue.destination as? GameViewController {
                if let settings = sender as? [Int] {
                    gameVC.settings = settings
                }
            }
        }
    }
}
