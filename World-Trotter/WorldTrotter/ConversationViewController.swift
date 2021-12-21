//
//  ConversationViewController.swift
//  WorldTrotter
//
//  Created by Alibi on 3/24/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateBackground()
    }
    
    func updateBackground() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        switch hour {
        case 7...18:
            self.view.backgroundColor = UIColor.lightGray
        default:
            self.view.backgroundColor = UIColor.darkGray
        }
    }
    
    func updateCelsiusLabel() {
        
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        let lettersSet = NSCharacterSet.letters
        
        if string.rangeOfCharacter(from: lettersSet as CharacterSet) != nil {
            return false
        } else {
            if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
                return false
            } else {
                return true
            }
        }
        
        
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        textField.resignFirstResponder()
    }
}
