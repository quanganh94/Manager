//
//  RegisterViewController.swift
//  Manager
//
//  Created by ZoZy on 5/26/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var user: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var btnRes: UIButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var userid: String = ""
    var errStr = "Username is already exist"
    var sucStr = "Register Successfully!"
    var stt:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.indicator.alpha=0
        self.label.text = stt
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn(sender: AnyObject) {
        self.indicator.alpha=1
        self.indicator.startAnimating()


        btnRes.enabled=false
        self.label.text = "Waiting..."
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/register.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "user="+user.text+"&pass="+pass.text+"&fullname="+name.text
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
            // do stuff in background queue
            let respond:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
            self.stt = respond

            // when ready to update model/UI dispatch that to main queue
            dispatch_async(dispatch_get_main_queue()) {
                if(self.stt=="s") {
                    self.label.text = self.sucStr
                    self.indicator.stopAnimating()
                    self.indicator.alpha=0}
                else if(self.stt=="e") {
                    self.label.text = self.errStr
                    self.btnRes.enabled=true
                    self.indicator.stopAnimating()
                    self.indicator.alpha=0
                }
            }
            } else {
                self.label.text = "Check your connection!"
                self.btnRes.enabled=true
                self.indicator.stopAnimating()
                self.indicator.alpha=0
            }
        }
    }
    
    
}