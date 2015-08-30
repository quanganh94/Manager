//
//  LoginViewController.swift
//  Manager
//
//  Created by ZoZy on 5/26/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var btnLog: UIButton!
    
    var username: String = ""

    override func viewWillAppear(animated: Bool) {
        var userid: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userid")
        if(userid != nil){
            username = userid as! String
            if(username != ""){
                self.performSegueWithIdentifier("Login", sender: self)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.alpha=0
        label.text=""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        self.indicator.alpha=1
        self.indicator.startAnimating()
        self.btnLog.enabled=false
        self.label.text = "Waiting..."
        
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/login.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        // Compose a query string
        let postString = "user="+user.text+"&pass="+pass.text
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
            // do stuff in background queue
            let respond:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
            
            // when ready to update model/UI dispatch that to main queue
            dispatch_async(dispatch_get_main_queue()) {
                if(respond=="false") {
                    self.label.text = "Wrong username or password"
                    self.btnLog.enabled=true
                    self.indicator.stopAnimating()
                    self.indicator.alpha=0
                } else {
                    self.label.text = "Logged in successfully!"
                    self.indicator.stopAnimating()
                    self.indicator.alpha=0
                    self.username = self.user.text
                    NSUserDefaults.standardUserDefaults().setObject(self.username, forKey: "userid")
                    NSUserDefaults.standardUserDefaults().setObject(respond, forKey: "fullname")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.performSegueWithIdentifier("Login", sender: self)
                }
            }
            } else {
                self.label.text = "Check your connection!"
                self.btnLog.enabled=true
                self.indicator.stopAnimating()
                self.indicator.alpha=0
            }
        }
        //        self.performSegueWithIdentifier("Login", sender: sender)
    }
    
}