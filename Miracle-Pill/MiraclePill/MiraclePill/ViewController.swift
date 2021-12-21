//
//  ViewController.swift
//  MiraclePill
//
//  Created by Alibi on 04.02.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var buyNowImage: UIButton!
    
    @IBOutlet weak var pillEmoji: UIImageView!
    @IBOutlet weak var miraclePillsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var zipText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    let states = ["Alaska", "Alabama", "California", "Maryland", "New York"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stateButtonPressed(_ sender: Any) {
        statePicker.isHidden = false
        stateButton.isHidden = true
        countryLabel.isHidden = true
        countryText.isHidden = true
        zipText.isHidden = true
        zipLabel.isHidden = true
        buyNowImage.isHidden = true
    }
    
    @IBAction func buyNowButtonPressed(_ sender: UIButton) {
        pillEmoji.isHidden = true
        miraclePillsLabel .isHidden = true
        priceLabel.isHidden = true
        divider.isHidden = true
        nameLabel.isHidden = true
        nameText.isHidden = true
        addressLabel.isHidden = true
        addressText.isHidden = true
        cityLabel.isHidden = true
        cityText.isHidden = true
        stateLabel.isHidden = true
        countryLabel.isHidden = true
        countryText.isHidden = true
        zipLabel.isHidden = true
        zipText.isHidden = true
        stateButton.isHidden = true
        buyNowImage.isHidden = true
        successImage.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateButton.setTitle(states[row], for: UIControlState())
        stateLabel.text = states[row]
        statePicker.isHidden = true
        stateButton.isHidden = false
        countryLabel.isHidden = false
        countryText.isHidden = false
        zipText.isHidden = false
        zipLabel.isHidden = false
        buyNowImage.isHidden = false
    }
}

