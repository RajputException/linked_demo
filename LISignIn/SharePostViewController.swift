//
//  SharePostViewController.swift
//  LISignIn
//
//  Created by Shubham on 27/07/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit


class SharePostViewController: UIViewController {

    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var profileUrl: [String : Any] = [:]
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = profileUrl["profileUrl"] as! String
         let url = URL.init(string: urlString)
        let urlReq = URLRequest(url: url!)
        print("Profle url \(urlString)")
        print("Profle urlReq \(urlReq)")
        
        webView.loadRequest(urlReq)
        // Do any additional setup after loading the view.
    }
    
    


}
