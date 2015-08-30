//
//  AddDeviceViewController.swift
//  Manager
//
//  Created by ZoZy on 5/28/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var devicename: UITextField!
    
    @IBOutlet weak var lbl: UILabel!
    
    var userid: String = ""
    override func viewDidLoad() {
        lbl.text = ""
        userid = NSUserDefaults.standardUserDefaults().objectForKey("userid")! as! String

    }

    @IBAction func btn(sender: AnyObject) {
        indicator.alpha=1
        indicator.startAnimating()
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/add_device.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "user="+self.userid+"&device="+self.devicename.text
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
                // do stuff in background queue
                let stt = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                // when ready to update model/UI dispatch that to main queue
                dispatch_async(dispatch_get_main_queue()) {
                    if(stt == "s"){
                        
                        self.indicator.stopAnimating()
                        self.lbl.text = "Device added successfully"
                    } else {
                        self.indicator.stopAnimating()
                        self.lbl.text = "Device already exist"

                    }
                    
                }
            } else {
                let alertView = UIAlertController(title: "Cannot connect to server", message: "Check Your Connection!", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
        }

    }
}
