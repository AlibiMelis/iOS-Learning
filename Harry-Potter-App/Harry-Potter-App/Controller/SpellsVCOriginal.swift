//
//  SpellsVCOriginal.swift
//  Harry-Potter-App
//
//  Created by Alibi on 12.04.2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class SpellsVCOriginal: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var spells = [Spells]()
    var filteredSpells = [Spells]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        DownloadSpellsDetails()
        searchBar.returnKeyType = UIReturnKeyType.done

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            
            return filteredSpells.count
        }
        return spells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpellCell", for: indexPath) as? SpellCell {
            let spell: Spells!
            if inSearchMode {
                
                spell = filteredSpells[indexPath.row]
                cell.updateUI(spellForCell: spell, indexPath: indexPath.row)
            } else {
                spell = spells[indexPath.row]
                cell.updateUI(spellForCell: spell, indexPath: indexPath.row)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredSpells = spells.filter({ $0.name.range(of: lower) != nil })
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
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
                        
                        spl.name = name.lowercased()
                    }
                    if let type = dict[i]["type"] {
                        
                        spl.type = type
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
