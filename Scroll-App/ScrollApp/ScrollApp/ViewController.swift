//
//  ViewController.swift
//  ScrollApp
//
//  Created by Alibi on 05.02.18.
//  Copyright © 2018 Alibi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    var images = [UIImageView]()
    
    override func viewDidAppear(_ animated: Bool) {

        let scrollWidth = scrollView.frame.size.width
        var newX: CGFloat = 0.0
        
        for x in 0...2 {
            let image = UIImage(named: "icon\(x).png")
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            
            newX = scrollWidth / 2 + scrollWidth * CGFloat(x)
            
            scrollView.addSubview(imageView)
            
            imageView.frame = CGRect(x: newX - 75, y: (scrollView.frame.size.height / 2) - 75, width: 150, height: 150)
            
        }
        
        scrollView.clipsToBounds = false
        
        scrollView.contentSize = CGSize(width: newX + 75, height: view.frame.size.height)
    }
}

