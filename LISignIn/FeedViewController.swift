//
//  FeedViewController.swift
//  LISignIn
//
//  Created by Shubham on 31/07/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let stUrl = "https://www.linkedin.com/feed/"
        let url = URL.init(string: stUrl)
        let urlReq = URLRequest(url: url!)
        webView.loadRequest(urlReq)
    }

  

}
