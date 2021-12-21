//
//  HeroVC.swift
//  Harry-Potter-App
//
//  Created by Alibi on 01.03.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class HeroVC: UIViewController {

    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroNameLbl: UILabel!
    @IBOutlet weak var heroSpecieLbl: UILabel!
    @IBOutlet weak var heroHouseLbl: UILabel!
    @IBOutlet weak var heroGenderLbl: UILabel!
    @IBOutlet weak var heroBirthYearLbl: UILabel!
    
    @IBOutlet weak var ancestryLbl: UILabel!
    @IBOutlet weak var aliveLbl: UILabel!
    @IBOutlet weak var eyeColorLbl: UILabel!
    @IBOutlet weak var hairColorLbl: UILabel!
    @IBOutlet weak var wandWoodLbl: UILabel!
    @IBOutlet weak var wandCoreLbl: UILabel!
    @IBOutlet weak var wandLengthLbl: UILabel!
    @IBOutlet weak var patronusLbl: UILabel!
    @IBOutlet weak var actorLbl: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var Lbl1: UILabel!
    @IBOutlet weak var Lbl2: UILabel!
    @IBOutlet weak var Lbl3: UILabel!
    @IBOutlet weak var Lbl4: UILabel!
    @IBOutlet weak var Lbl5: UILabel!
    @IBOutlet weak var Lbl6: UILabel!
    @IBOutlet weak var Lbl7: UILabel!
    @IBOutlet weak var Lbl8: UILabel!
    @IBOutlet weak var Lbl9: UILabel!
    
    
    var potter: Potters!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeroView(potter: potter)
    }

    func configureHeroView(potter: Potters) {
        //THE FUNCTION TO CHANGE THE DATA INSIDE THE HEROVIEW
        let url = URL(string: potter.imageURL)!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    self.heroImg.image = UIImage(data: data)
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        
        heroNameLbl.text = potter.name.capitalized
        if potter.house != "" {
            heroHouseLbl.text = potter.house
        } else {
            heroHouseLbl.text = "unknown"
        }
        heroGenderLbl.text = potter.gender
        if potter.birthYear == "" || potter.birthYear == nil {
            heroBirthYearLbl.text = "unknown"
        } else {
            heroBirthYearLbl.text = potter.birthYear
        }
        heroSpecieLbl.text = potter.specie
        ancestryLbl.text = potter.ancestry
        if potter.alive {
            aliveLbl.text = "Alive"
        } else {
            aliveLbl.text = "Dead"
        }
        eyeColorLbl.text = potter.eyeColor
        hairColorLbl.text = potter.hairColor
        if potter.wandWood == "" || potter.wandWood == nil {
            wandWoodLbl.text = "unknown"
        } else {
            wandWoodLbl.text = potter.wandWood
        }
        
        if potter.wandCore == "" || potter.wandCore == nil {
            wandCoreLbl.text = "unkown"
        } else {
            wandCoreLbl.text = potter.wandCore
        }
        if potter.wandLength == "" || potter.wandLength == nil {
            wandLengthLbl.text = "unkown"
        } else {
            wandLengthLbl.text = potter.wandLength
        }
        if potter.patronus == "" || potter.patronus == nil {
            patronusLbl.text = "unknown"
        } else {
            patronusLbl.text = potter.patronus
        }
        actorLbl.text = potter.actor
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        //Changes occuring when user selects another segment in segmented control
        if segment.selectedSegmentIndex == 0 {
            Lbl1.isHidden = true
            Lbl2.isHidden = true
            Lbl3.isHidden = true
            Lbl4.isHidden = true
            Lbl5.isHidden = true
            Lbl6.isHidden = true
            Lbl7.isHidden = true
            Lbl8.isHidden = true
            Lbl9.isHidden = true
            ancestryLbl.isHidden = true
            aliveLbl.isHidden = true
            eyeColorLbl.isHidden = true
            hairColorLbl.isHidden = true
            wandCoreLbl.isHidden = true
            wandWoodLbl.isHidden = true
            wandLengthLbl.isHidden = true
            patronusLbl.isHidden = true
            actorLbl.isHidden = true
            heroImg.isHidden = false
        }
        if segment.selectedSegmentIndex == 1 {
            Lbl1.isHidden = false
            Lbl2.isHidden = false
            Lbl3.isHidden = false
            Lbl4.isHidden = false
            Lbl5.isHidden = false
            Lbl6.isHidden = false
            Lbl7.isHidden = false
            Lbl8.isHidden = false
            Lbl9.isHidden = false
            ancestryLbl.isHidden = false
            aliveLbl.isHidden = false
            eyeColorLbl.isHidden = false
            hairColorLbl.isHidden = false
            wandCoreLbl.isHidden = false
            wandWoodLbl.isHidden = false
            wandLengthLbl.isHidden = false
            patronusLbl.isHidden = false
            actorLbl.isHidden = false
            heroImg.isHidden = true
        }
    }
    
}
