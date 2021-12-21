//
//  CharactersVCViewController.swift
//  Harry-Potter-App
//
//  Created by Alibi on 28.02.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class CharactersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    var potters = [Potters]() //Main array of characters, initially empty
    var filteredPotters = [Potters]() //Array for data while using the searchBar
    var inSearchMode = false
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self

        searchBar.returnKeyType = UIReturnKeyType.done
        
        DownloadCharacterDetails()
        
    }
    
    func DownloadCharacterDetails() { //Function for getting needed values from JSON file
        let url = Bundle.main.url(forResource: "characters", withExtension: "json")
        let data = NSData(contentsOf: url!)
        do {
            let object = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) //Downloading data from JSON file
            if let dictionary = object as? [Dictionary<String, AnyObject>] {
                
                for i in 0...24 { //Creating a loop for all 25 characters
                    let pott = Potters()
                    if let name = dictionary[i]["name"] as? String { //Every property has "key" to take the value from it
                        
                        pott.name = name.lowercased()
                    }
                    
                    if let imageURL = dictionary[i]["image"] as? String {
                        
                        pott.imageURL = imageURL
                    }
                    if let ancestry = dictionary[i]["ancestry"] as? String {
                        pott.ancestry = ancestry
                    }
                    
                    if let house = dictionary[i]["house"] as? String {
                        
                        pott.house = house
                    }
                    if let birthYear = dictionary[i]["yearOfBirth"] as? Int {
                        
                        pott.birthYear = "\(birthYear)"
                    }
                    if let gender = dictionary[i]["gender"] as? String {
                        pott.gender = gender
                    }
                    if let specie = dictionary[i]["species"] as? String {
                        
                        pott.specie = specie
                    }
                    if let eyeColor = dictionary[i]["eyeColour"] as? String {
                        
                        pott.eyeColor = eyeColor
                    }
                    if let hairColor = dictionary[i]["hairColour"] as? String {
                        
                        pott.hairColor = hairColor
                    }
                    if let patronus = dictionary[i]["patronus"] as? String {
                        
                        pott.patronus = patronus
                    }
                    if let actor = dictionary[i]["actor"] as? String {
                        
                        pott.actor = actor
                    }
                    if let alive = dictionary[i]["alive"] as? Bool {
                        
                        pott.alive = alive
                    }
                    if let wand = dictionary[i]["wand"] as? Dictionary<String, AnyObject> {
                        if let wandWood = wand["wood"] as? String {
                            pott.wandWood = wandWood
                        }
                        if let wandCore = wand["core"] as? String {
                            pott.wandCore = wandCore
                        }
                        if let wandLength = wand["length"] as? String {
                            if wandLength != "" {
                                pott.wandLength = wandLength
                                print(pott.wandLength)
                            } else {
                                pott.wandLength = "unknown"
                            }
                        }
                    }
                    potters.append(pott) //After getting all properties of the character we add this character to the main array
                    
                }
            }
        } catch let err as NSError {
            print(err.debugDescription) //The description of the bug will be written if it occurs
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Setting the cell for collection view, the cells will be repeatedly used as much as needed
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PotterCell", for: indexPath) as? PotterCell {
            
            let pott: Potters!
            
            if inSearchMode{
                pott = filteredPotters[indexPath.row]
                cell.configureCell(potterrr: pott)  //The fuction that changes the label and image in the cell
            } else {
                pott = potters[indexPath.row]
                cell.configureCell(potterrr: pott)
            }
            return cell
        } else {
            
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Passing the data when the certain character is chosen
        var pott: Potters!
        
        if inSearchMode {
            pott = filteredPotters[indexPath.row]
        } else {
            pott = potters[indexPath.row]
        }
        
        performSegue(withIdentifier: "HeroVC", sender: pott) //Pass to the another view
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPotters.count
        }
        return potters.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height: 110)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Changes that occur when user uses searchBar
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPotters = potters.filter({ $0.name.range(of: lower) != nil })
            collection.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //What definite data is going to be passed through segue
        if segue.identifier == "HeroVC" {
            if let heroVC = segue.destination as? HeroVC {
                if let pott = sender as? Potters {
                    heroVC.potter = pott
                }
            }
        }
    }
    
    
    
}
