//
//  ViewController.swift
//  Poisson-calculator
//
//  Created by Alibi on 05/09/2018.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var equalAns: UILabel!
    @IBOutlet weak var notLessAns: UILabel!
    @IBOutlet weak var notGreaterAns: UILabel!
    @IBOutlet weak var greaterAns: UILabel!
    @IBOutlet weak var lessAns: UILabel!
    
    @IBOutlet weak var lambda: UITextField!
    @IBOutlet weak var success: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    
    let e = 2.7182818284590452353602874713527
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = CGFloat(18.0)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func factorial(factorialNumber: Double) -> Double {
        if factorialNumber == 0 {
            return 1
        } else {
            return factorialNumber * factorial(factorialNumber: factorialNumber - 1)
        }
    }

    
    func equalFormula(lambda: Double, x: Int) -> Double {
        let a = (pow(e, -lambda) * pow(lambda, Double(x))) / factorial(factorialNumber: Double(x))
        return Double(round(10000 * a)/10000)
    }
    
    
    func notGreaterFormula(lambda: Double, x: Int) -> Double {
        
        var sum = 0.0
        
        for i in 0...x {
            sum += equalFormula(lambda: lambda, x: i)
        }
        return Double(round(10000 * sum)/10000)
    }
    
    func notLessFormula(lambda: Double, x: Int) -> Double {
        
        var sum = 0.0
        
        for i in 0..<x  {
            sum += equalFormula(lambda: lambda, x: i)
        }
        let b = 1.0 - sum
        
        return Double(round(10000 * b)/10000)
    }
    
    func lessFormula(lambda: Double, x: Int) -> Double {
        
        var sum = 0.0
        
        for i in 0..<x {
            sum += equalFormula(lambda: lambda, x: i)
        }
        return Double(round(10000 * sum)/10000)
    }
    
    func greaterFormula(lambda: Double, x: Int) -> Double {
        
        var sum = 0.0
        
        for i in 0...x  {
            sum += equalFormula(lambda: lambda, x: i)
        }
        
        let b = 1.0 - sum
        return Double(round(10000 * b)/10000)
    }
    
    func calculate() {
        let lambda = Double(self.lambda.text!)
        let success = Double(self.success.text!)
        
        let equal = equalFormula(lambda: lambda!, x: Int(success!))
        self.equalAns.text = "\(equal)"
        
        let notGreater = notGreaterFormula(lambda: lambda!, x: Int(success!))
        self.notGreaterAns.text = "\(notGreater)"
        
        let notLess = notLessFormula(lambda: lambda!, x: Int(success!))
        self.notLessAns.text = "\(notLess)"
        
        let greater = greaterFormula(lambda: lambda!, x: Int(success!))
        self.greaterAns.text = "\(greater)"
        
        let less = lessFormula(lambda: lambda!, x: Int(success!))
        self.lessAns.text = "\(less)"
        
    }
    

    
    @IBAction func calculateBtnPressed(_ sender: UIButton) {
        
        calculate()
    }
    
}

