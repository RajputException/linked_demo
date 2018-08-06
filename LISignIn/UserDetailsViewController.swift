//
//  UserDetailsViewController.swift
//  LISignIn
//
//  Created by Shubham on 25/07/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    var dataReceived : [String :  Any] = [:]
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Data Received in USERVC \(dataReceived)")
        setDataInVC()
      
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sharePost(_ sender: Any) {
        
            print("share called")
            LISDKSessionManager.createSession(withAuth:
                [LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {(sucess) in
                    let session = LISDKSessionManager.sharedInstance().session
                    print("Session ",session!)
                    //let url = "https://api.linkedin.com/v1/people/~"
                    if LISDKSessionManager.hasValidSession(){
                        let url: String = "https://api.linkedin.com/v1/people/~/shares"
                        
                        let payloadStr: String = "{\"comment\":\"YOUR_APP_LINK_OR_WHATEVER_YOU_WANT_TO_SHARE\",\"visibility\":{\"code\":\"anyone\"}}"
                        
                        let payloadData = payloadStr.data(using: String.Encoding.utf8)
                        
                        LISDKAPIHelper.sharedInstance().postRequest(url, body: payloadData, success: { (response) in
                            print(response!.data)
                        }, error: { (error) in
                            print(error!)
                            
                            let alert = UIAlertController(title: "Alert!", message: "Something went wrong", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
            }) {(error) in
                print("Error \(String(describing: error))")
            }
            
            print("share ended")
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewProfile"
        {
            let shareVc = segue.destination as! SharePostViewController
            shareVc.profileUrl = dataReceived
        }
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDataInVC()
    {
        print("Begin of code")
        let imageUrl = dataReceived["picUrl"] as! String
        if let url = URL(string: imageUrl ) {
            imageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
        fullName.text = dataReceived["fullName"] as? String
        jobTitle.text = dataReceived["JobTitle"] as? String
        companyName.text = dataReceived["Company"] as? String
        location.text = dataReceived["Location"] as? String
    }

    @IBAction func ViewonLikedIn(_ sender: Any) {
        performSegue(withIdentifier: "viewProfile", sender: dataReceived)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
