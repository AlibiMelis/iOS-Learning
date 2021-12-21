//
//  SpellsVC.swift
//  Harry-Potter-App
//
//  Created by Alibi on 19.04.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class SpellsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var splNameLbl: UILabel!
    @IBOutlet weak var splTypeLbl: UILabel!
    @IBOutlet weak var splEffectLbl: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var spells = [Spells]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DownloadSpellsDetails()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        splNameLbl.text = spells[0].name
        splTypeLbl.text = spells[0].type
        splEffectLbl.text = spells[0].effect
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return spells.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: spells[row].name, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        splNameLbl.text = spells[row].name
        splTypeLbl.text = spells[row].type
        splEffectLbl.text = spells[row].effect
        
    }
    func DownloadSpellsDetails() {
        
        let url = Bundle.main.url(forResource: "spells", withExtension: "json")
        let data = NSData(contentsOf: url!)
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            if let dict = object as? [Dictionary<String, String>] {
                var spl = Spells()
                for i in 0...90 {
                    
                    if let name = dict[i]["name"] {
                        
                        spl.name = name
                    }
                    if let type = dict[i]["type"] {
                        
                        spl.type = type.capitalized
                    }
                    if let effect = dict[i]["effect"] {
                        
                        spl.effect = effect
                    }
                    
                    spells.append(spl)
                    spl = Spells()
                }
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}
