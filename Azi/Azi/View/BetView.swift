//
//  BetView.swift
//  Azi
//
//  Created by Alibi on 5/16/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import PureLayout

class BetView: UIView {
    //MARK: - Properties
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    var minBet: Double = 100
    var maxBet: Double = 100
    
    var bet: Double = 100.0 {
        didSet {
            betLabel.text = "\(numberFormatter.string(from: NSNumber(value: bet))!)"
        }
    }
    
    var betSlider = UISlider()
    let oneXButton: UIButton = {
        let oneX = UIButton()
        oneX.setTitle("Min", for: .normal)
        oneX.backgroundColor = UIColor.green
        oneX.addTarget(self, action: #selector(BetView.oneXPressed(_:)), for: .touchUpInside)
        oneX.autoSetDimensions(to: CGSize(width: 60, height: 40))
        return oneX
    }()
    let twoXButton: UIButton = {
        let twoX = UIButton()
        twoX.setTitle("Double", for: .normal)
        twoX.backgroundColor = UIColor.green
        twoX.addTarget(self, action: #selector(BetView.twoXPressed(_:)), for: .touchUpInside)
        twoX.autoSetDimensions(to: CGSize(width: 60, height: 40))
        return twoX
    }()
    var betLabel: UILabel = {
        let bl = UILabel()
        bl.font = UIFont.boldSystemFont(ofSize: 16)
        bl.textAlignment = .left
        return bl
    }()
    
    
    //MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        betSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        addSubview(oneXButton)
        addSubview(twoXButton)
        addSubview(betSlider)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    func configureBetView(minBet: Double, maxBet: Double) {
        self.minBet = minBet
        self.maxBet = maxBet
        
        betLabel.text = "\(minBet)"
        
        betSlider.isContinuous = true
        betSlider.minimumValue = Float(minBet)
        betSlider.maximumValue = Float(maxBet)
        betSlider.setValue(Float(minBet), animated: true)
        betSlider.addTarget(self, action: #selector(BetView.sliderDidChange(_:)), for: .valueChanged)
        
        let verticalStack = UIStackView(arrangedSubviews: [betLabel, oneXButton, twoXButton])
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 8
        addSubview(verticalStack)
        let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 12)
        verticalStack.autoPinEdgesToSuperviewEdges(with: inset, excludingEdge: .right)
        
        betSlider.autoPinEdge(toSuperviewEdge: .top)
        betSlider.autoPinEdge(toSuperviewEdge: .bottom)
        betSlider.autoSetDimension(.width, toSize: 170)
    }
    
    func getBetAmount() -> Double {
        return bet
    }
    
    @objc func sliderDidChange(_ sender: UISlider) {
        bet = Double(sender.value)
    }
    
    @objc func oneXPressed(_ sender: UIButton) {
        bet = minBet
    }
    @objc func twoXPressed(_ sender: UIButton) {
        let doubleBet = bet * 2
        if doubleBet > maxBet {
            bet = maxBet
        } else {
            bet = doubleBet
        }
    }
}
