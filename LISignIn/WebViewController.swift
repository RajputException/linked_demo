//
//  WebViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    
    // MARK: Constants
    
    let linkedInKey = "86sqb7txbyxcaq"
    
    let linkedInSecret = "NckpkBXi0PEqZGEh"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.delegate = self
        startAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"
        
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth"

        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile"
        
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(String(describing: redirectURL))&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
       // print(" URL --> \(authorizationURL) <---")
        
        let request = NSURLRequest(url: NSURL(string: authorizationURL)! as URL)
        webView.loadRequest(request as URLRequest)
        
    }
    @IBAction func cancelLoginButton(_ sender: Any) {
        
        self.dismiss(animated: true,completion: nil)
        
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
       // print("webView Method Called")
        let url = request.url
       // print("--> URL in webView \(url!) <--")
        
        if url?.host == "com.appcoda.linkedin.oauth" {
            if url?.absoluteString.range(of: "code") != nil {
                // Extract the authorization code.
                let urlParts = url?.absoluteString.components(separatedBy: "?")
                print("-->URLparts \(urlParts![1]) <--")
                let code = urlParts![1].components(separatedBy: "=")[1]
                print("---> Access Token \(code) <---- ")
               // let endIndex = code.index(code.endIndex, offsetBy: -6)
               // let truncated = code.substring(to: endIndex)
               //  print("---> Access Token Final \(truncated) <---- ")
                requestForAccessToken(authorizationCode: code)
            }
        }
        
        return true
    }
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth"
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        let postData = postParams.data(using: String.Encoding.utf8)
        // initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        // a POST request.
        request.httpMethod = "POST"
        //setting the HTTP body using the postData object created above
        request.httpBody = postData
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                print("Status Code \(statusCode) <--")
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                 //   print("Data in Dictionary \(dataDictionary) <---")
                    let accessToken = dataDictionary["access_token"] as! String
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
        
    }
    @IBAction func dismiss(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
