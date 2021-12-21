//
//  ViewController.swift
//  Harry-Potter-App
//
//  Created by Alibi on 28.02.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit
import AVFoundation


class MainVC: UIViewController {
    
    var musicPlayer: AVAudioPlayer!
    
    @IBOutlet weak var musicBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playMusic()
    }

    func playMusic() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1  //Music will turn on again even if it is finished
            if musicPlayer.isPlaying == false {
                musicPlayer.play()
            } else {
            
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    @IBAction func musicBtnPressed(_ sender: Any) {
        //Button for pausing and playing music
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            musicBtn.setTitle("          Off", for: .normal)
        } else {
            musicPlayer.play()
            musicBtn.setTitle("          On", for: .normal)
        }
    }
    
}

