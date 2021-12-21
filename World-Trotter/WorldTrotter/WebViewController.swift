//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Alibi on 3/26/20.
//  Copyright © 2020 Alibi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.cityu.edu.hk")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
