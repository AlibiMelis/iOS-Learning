//
//  MainViewController.swift
//  SpyFall@CityUEdition
//
//  Created by Alibi on 3/27/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        
        let mainBg = UIImage(named: "mainbg")
        view.backgroundColor = UIColor(patternImage: mainBg!)
    }
    
    
    @IBAction func startGameBtnPressed(_ sender: UIButton) {
        
        let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SettingsVC")
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true, completion: nil)
    }
}
