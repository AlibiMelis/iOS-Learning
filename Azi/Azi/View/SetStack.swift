//
//  SetStack.swift
//  Azi
//
//  Created by Alibi on 5/15/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import PureLayout
import Firebase
import SpriteKit

class SetStack: UIView {
    //MARK: - Properties
    
    private var game: Game!
    private var minStack: Double!
    
    private var myStack: Double! {
        didSet {
            stackLabel.text = "\(numberFormatter.string(from: NSNumber(value: myStack!))!)"
        }
    }
    
    private var stackSlider: UISlider!
    
    
    private var stackLabel: UILabel = {
        let sl = UILabel()
        sl.font = UIFont.boldSystemFont(ofSize: 18)
        sl.textAlignment = .center
        return sl
    }()
    private var descriptionLabel: UILabel = {
        let dl = UILabel()
        dl.font = UIFont.boldSystemFont(ofSize: 14)
        dl.text = "Select stack from your "
        dl.textAlignment = .right
        return dl
    }()
    private var myMoneyLabel: UILabel = {
        let mm = UILabel()
        mm.font = UIFont.boldSystemFont(ofSize: 16)
        mm.textAlignment = .left
        return mm
    }()
    
    private var okButton: UIButton = {
        let ok = UIButton()
        ok.setTitle("OK", for: .normal)
        ok.backgroundColor = UIColor.blue
        ok.addTarget(self, action: #selector(SetStack.okButtonTapped(_:)), for: .touchUpInside)
        return ok
    }()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    //MARK: - Initialiser
    
    override init(frame: CGRect) {
        stackSlider = UISlider()
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        addSubview(stackSlider)
        addSubview(stackLabel)
        addSubview(descriptionLabel)
        addSubview(okButton)
        
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    @objc func okButtonTapped(_ sender: UIButton) {
        
        let stack = self.numberFormatter.number(from: self.stackLabel.text!)
        DataService.ds.REF_GAMES.child(game.tableID).child("players").child(currentUserUID).updateChildValues(["stack": stack!])
        DataService.ds.REF_CURRENT_USER.child("money").observeSingleEvent(of: .value, with: { (snapshot) in
            if let money = snapshot.value as? Double {
                print("ALIBI: Getting stack from money")
                let newMoney = money - (stack as! Double)
                DataService.ds.REF_CURRENT_USER.updateChildValues(["money": newMoney])
            }
        })
        if let view = self.superview as? SKView {
            if let vc = view.next as? GameViewController {
                vc.scene.isUserInteractionEnabled = true
                vc.backView.removeFromSuperview()
            }
        }
        self.removeFromSuperview()
    }
    
    func configureStackView(inGame game: Game) {
        
        self.game = game
        minStack = Double(game.stake) * 2
        DataService.ds.REF_CURRENT_USER.child("money").observeSingleEvent(of: .value, with: { (snapshot) in
            if let money = snapshot.value as? Double {
                print("ALIBI: Could get my money")
                self.stackSlider.maximumValue = Float(money)
                self.myMoneyLabel.text = "\(money)"
                self.stackSlider.setValue(Float((self.minStack + money) / 2), animated: true)
                self.stackLabel.text = self.numberFormatter.string(from: NSNumber(value: self.stackSlider.value))
            }
        })
        print("ALIBI: Min stake is \(game.stake)")
       
        
        stackSlider.isUserInteractionEnabled = true
        stackSlider.isEnabled = true
        stackSlider.minimumValue = Float(game.stake)
        
        print("ALIBI: min \(stackSlider.minimumValue)")
        print("ALIBI: max \(stackSlider.maximumValue)")
        stackSlider.isContinuous = true
        stackSlider.addTarget(self, action: #selector(SetStack.stackSliderDidChange(_:)), for: .valueChanged)
        
        let myMoneyStack = UIStackView(arrangedSubviews: [descriptionLabel, myMoneyLabel])
        myMoneyStack.distribution = .fillProportionally
        myMoneyStack.axis = .horizontal
        myMoneyStack.spacing = 5
        myMoneyStack.autoSetDimension(.height, toSize: 40)
        addSubview(myMoneyStack)
        let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        myMoneyStack.autoPinEdgesToSuperviewEdges(with: inset, excludingEdge: .bottom)
        
        stackLabel.autoPinEdge(.top, to: .bottom, of: myMoneyStack)
        stackLabel.autoPinEdge(toSuperviewEdge: .leading)
        stackLabel.autoPinEdge(toSuperviewEdge: .trailing)
        stackLabel.textAlignment = .center
        stackLabel.autoSetDimension(.height, toSize: 40)
        
        stackSlider.autoPinEdge(.top, to: .bottom, of: stackLabel, withOffset: 8)
        stackSlider.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20)
        stackSlider.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -20)
    
        let okInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        okButton.autoSetDimension(.height, toSize: 54)
        okButton.autoPinEdgesToSuperviewEdges(with: okInset, excludingEdge: .top)
        okButton.autoPinEdge(.top, to: .bottom, of: stackSlider, withOffset: 16)
    }
    
    @objc func stackSliderDidChange(_ sender: UISlider) {
        myStack = Double(sender.value)
    }
}
