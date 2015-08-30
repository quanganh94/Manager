//
//  ChangePassViewController.swift
//  Manager
//
//  Created by ZoZy on 5/27/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {
    
    
    var userid: String = ""
    
    @IBOutlet weak var current: UITextField!
    
    @IBOutlet weak var newpass: UITextField!
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func btn(sender: AnyObject) {
        self.indicator.alpha=1
        self.indicator.startAnimating()
        self.btnDone.enabled=false
        self.label.text = "Waiting..."
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/changepass.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "user="+userid+"&pass="+current.text+"&new="+newpass.text
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            
            if(error == nil){
                // do stuff in background queue
                let respond:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
                // when ready to update model/UI dispatch that to main queue
                dispatch_async(dispatch_get_main_queue()) {
                    if(respond=="false") {
                        self.label.text = "Wrong current password"
                        self.btnDone.enabled=true
                        self.indicator.alpha=0
                    } else {
                        self.label.text = "Password changed successfully!"
                        self.indicator.alpha=0
                    }
                }
            } else {
                let alertView = UIAlertController(title: "No Internet Connection", message: "Check Your Connection!", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        userid = NSUserDefaults.standardUserDefaults().objectForKey("userid")! as! String
        indicator.alpha=0
        label.text = ""
    }
}
