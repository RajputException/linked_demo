//
//  ViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var btnGetProfileInfo: UIButton!
    
    @IBOutlet weak var btnOpenProfile: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnSignIn.isEnabled = true
        btnOpenProfile.isHidden = true
        btnOpenProfile.isHidden = true
        btnGetProfileInfo.isEnabled = false
        btnGetProfileInfo.isHidden = true
        print("------------------------")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForExistingAccessToken()
    }
    // MARK: IBAction Functions

    @IBAction func getProfileInfo(sender: AnyObject) {
        
        getProfile()
        btnGetProfileInfo.isEnabled = false
        btnGetProfileInfo.titleLabel?.text = ""
        }
    
    @IBAction func openProfileUrlInVC(_ sender: Any) {
        
        
    }
    func getProfile()
    {
        
        print("Get Profile Called progress started")
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "आपका नेट स्लो है")
        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
            // Specify the URL string that we'll get the profile info from.
            let targetURLString = "https://api.linkedin.com/v1/people/~:(id,public-profile-url,picture-url,first-name,last-name,email-address,positions)?format=json"
            let t = URL.init(string: targetURLString)
            let request = NSMutableURLRequest(url: t!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                // Get the HTTP status code of the request.
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any ]
                        let profileURLString = dataDictionary["publicProfileUrl"] as! String
                        //   print("Data Dictionary #--> \(dataDictionary) <--# ")
                        self.fetchingUserDetails(dataDictionary: dataDictionary)
                        
                        //  print("Title \(String(describing: title)) <--/")
                        //  print("Values -> \(String(describing: company))) <- ")
                        
                        DispatchQueue.main.async(execute: {
                            self.btnOpenProfile.setTitle("SignIn Successfull", for: .normal)
                            // print("Profile URL \(profileURLString) <--- ")
                            self.btnOpenProfile.isHidden = false
                        })
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                   
                }

                SVProgressHUD.dismiss()
                print("Task Ended // progress ende")
            }
            task.resume()
        }
        
        print("Get Profile Ended")
    
    }
    


    func fetchingUserDetails(dataDictionary : [String : Any])
    {
        let firstName = dataDictionary["firstName"] as! String
        let lastName = dataDictionary["lastName"] as! String
        let fullName = "\(firstName) \(lastName)"
        let positions = dataDictionary["positions"] as! [String : Any]
        let values: NSArray = positions["values"] as! NSArray
        let company: NSDictionary = values[0] as! NSDictionary
        let name = company["company"] as! [String : Any]
        let title = company["title"] as! String
        let currentCompany = name["name"] as! String
        let location = company["location"] as! [String : Any]
        let picUrl = dataDictionary["pictureUrl"]
        let city = location["name"]
        let dataReceived = ["fullName" : fullName,"picUrl" : picUrl!, "JobTitle" : title, "Company" : currentCompany, "Location" : city!, "profileUrl" : dataDictionary["publicProfileUrl"] as! String] as [String : Any]
        print(dataReceived)
        d = dataReceived
        
    }
    var flag = 0
    @IBAction func sigInClicked(_ sender: Any) {
        self.btnGetProfileInfo.isEnabled = true
        self.btnGetProfileInfo.isHidden = false
    }
    var d: [String : Any] = [:]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsVC"
        {
            let detVC = segue.destination as! UserDetailsViewController
            detVC.dataReceived = d
        }
    
    }
    
    func sendToUserDetailsVC(dataReceived : [String : Any])
    {
        print("DataSended \(dataReceived)")
            performSegue(withIdentifier: "detailsVC", sender: dataReceived)
        
    }
    @IBAction func openProfileInSafari(sender: AnyObject) {
       sendToUserDetailsVC(dataReceived: d)
        
    }
    func checkForExistingAccessToken() {
        // UserDefaults.standard.object(forKey: "LIAccessToken")
            btnSignIn.isEnabled = true
            btnGetProfileInfo.isEnabled = true
        
    }
    
  
    
}

