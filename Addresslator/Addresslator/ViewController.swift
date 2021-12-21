//
//  ViewController.swift
//  Addresslator
//
//  Created by Alibi on 23/01/2019.
//  Copyright © 2019 Alibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ip1: MyTextField!
    @IBOutlet weak var ip2: MyTextField!
    @IBOutlet weak var ip3: MyTextField!
    @IBOutlet weak var ip4: MyTextField!
    
    
    @IBOutlet weak var subnet1: MyTextField!
    @IBOutlet weak var subnet2: MyTextField!
    @IBOutlet weak var subnet3: MyTextField!
    @IBOutlet weak var subnet4: MyTextField!
    
    
    @IBOutlet weak var host1: MyTextField!
    @IBOutlet weak var host2: MyTextField!
    @IBOutlet weak var host3: MyTextField!
    @IBOutlet weak var host4: MyTextField!
    
    
    @IBOutlet weak var net1: MyTextField!
    @IBOutlet weak var net2: MyTextField!
    @IBOutlet weak var net3: MyTextField!
    @IBOutlet weak var net4: MyTextField!
    
    
    @IBOutlet weak var ipBin: UILabel!
    @IBOutlet weak var subnetBin: UILabel!
    @IBOutlet weak var hostBin: UILabel!
    @IBOutlet weak var netBin: UILabel!
    
    
    var subn1 = String()
    var subn2 = String()
    var subn3 = String()
    var subn4 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func updateIPBinaryForm() {
        var ipFinal: String = ""
        if let ip1Step1 = Int(ip1.text!) {
            let ip1Step2 = decimalToBinary(decimal: ip1Step1)
            let ip1Final = pad(string: ip1Step2)
            ipFinal += ip1Final
        }
        if let ip2Step1 = Int(ip2.text!) {
            let ip2Step2 = decimalToBinary(decimal: ip2Step1)
            let ip2Final = pad(string: ip2Step2)
            ipFinal += ip2Final
        }
        if let ip3Step1 = Int(ip3.text!) {
            let ip3Step2 = decimalToBinary(decimal: ip3Step1)
            let ip3Final = pad(string: ip3Step2)
            ipFinal += ip3Final
        }
        if let ip4Step1 = Int(ip4.text!) {
            let ip4Step2 = decimalToBinary(decimal: ip4Step1)
            let ip4Final = pad(string: ip4Step2)
            ipFinal += ip4Final
        }
        ipBin.text = ipFinal
    }
    
    func updateSubnetBinaryForm() {
        var subnetFinal: String = ""
        if let subnet1Step1 = Int(subnet1.text!) {
            let subnet1Step2 = decimalToBinary(decimal: subnet1Step1)
            let subnet1Final = pad(string: subnet1Step2)
            subnetFinal += subnet1Final
        }
        if let subnet1Step1 = Int(subnet2.text!) {
            let subnet2Step2 = decimalToBinary(decimal: subnet1Step1)
            let subnet2Final = pad(string: subnet2Step2)
            subnetFinal += subnet2Final
        }
        if let subnet3Step1 = Int(subnet3.text!) {
            let subnet3Step2 = decimalToBinary(decimal: subnet3Step1)
            let subnet3Final = pad(string: subnet3Step2)
            subnetFinal += subnet3Final
        }
        if let subnet4Step1 = Int(subnet4.text!) {
            let subnet4Step2 = decimalToBinary(decimal: subnet4Step1)
            let subnet4Final = pad(string: subnet4Step2)
            subnetFinal += subnet4Final
        }
        subnetBin.text = subnetFinal
    }
        //subnetBin.text = "\(pad(string: decimalToBinary(decimal: Int(subnet1.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(subnet2.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(subnet3.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(subnet4.text!)!)))"
        
        //hostBin.text = "\(pad(string: decimalToBinary(decimal: Int(host1.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(host2.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(host3.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(host4.text!)!)))"
        
        //netBin.text = "\(pad(string: decimalToBinary(decimal: Int(net1.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(net2.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(net3.text!)!)))  \(pad(string: decimalToBinary(decimal: Int(net4.text!)!)))"
    

    func decimalToBinary(decimal: Int) -> String {
        
        let decimal = decimal
        let binary = String(decimal, radix: 2)
        return binary
    }
    
    func pad(string : String) -> String {
        var padded = string
        for _ in 0..<(8 - string.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    
    func findingAddresses() {
        
        if (subnet1.text != "255") {
            var sum = 0
            for char in subnet1.text! {
                
                if (char == "1") {
                    sum += 1
                }
            }
        } else if (subnet2.text != "255") {
            
            
        } else if (subnet3.text != "255") {
            
            
        } else if (subnet4.text != "255") {
            
            
        }
    }
    
    
    
    
    @IBAction func processBtnPressed(_ sender: Any) {
        if (ip1 != nil && subnet1 != nil) {
            
            findingAddresses()
        }
        updateIPBinaryForm()
    }
    

}

