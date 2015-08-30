//
//  DeviceViewController.swift
//  Manager
//
//  Created by ZoZy on 5/26/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableIndicator: UIActivityIndicatorView!
    var nav_title: String = ""
    var user_title: String = ""
    var userid: String = ""
    var stt: String = ""
    var json = Array<AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        indicator.alpha=0
        self.title = nav_title
        self.user.text = user_title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transfer(sender: AnyObject) {
        indicator.alpha=1
        indicator.startAnimating()
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/update.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "user="+self.userid+"&device="+self.nav_title
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
            // do stuff in background queue
            self.stt = NSString(data: data, encoding: NSUTF8StringEncoding)! as String

            // when ready to update model/UI dispatch that to main queue
            dispatch_async(dispatch_get_main_queue()) {
                if(self.stt != ""){
                    self.user.text = self.stt
                    self.readData()
                    self.indicator.alpha=0
                }
                
            }
            } else {
                let alertView = UIAlertController(title: "Cannot connect to server", message: "Check Your Connection!", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)

            }
        }

    }
    
//    func readData(){
//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            var origin : String = self.title!
//            var link = origin.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
//
//            let url=NSURL(string:"http://zozy.me/devicemanager/history.php?device=" + link)
//            let allContactsData=NSData(contentsOfURL:url!)
//            var allContacts: AnyObject! = NSJSONSerialization.JSONObjectWithData(allContactsData!, options: NSJSONReadingOptions(0), error: nil)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.json = allContacts as Array<AnyObject>
//                self.tableView.reloadData()
//            })
//        })
//        
//    }
    
    func readData(){
        self.tableIndicator.startAnimating()

        let myUrl = NSURL(string: "http://zozy.me/devicemanager/history.php");
        let request = NSMutableURLRequest(URL:myUrl!)
        let postString = "device=" + self.title!
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        request.HTTPMethod = "POST";
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
                // do stuff in background queue
                let respond:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
                var allContacts: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: nil)
                // when ready to update model/UI dispatch that to main queue
                dispatch_async(dispatch_get_main_queue()) {
                    self.json = allContacts as! Array<AnyObject>
                    if(self.json.count>0) {
                        self.tableIndicator.stopAnimating()
                    }
                    self.tableView.reloadData()
                }
            }
            else {
                let alertView = UIAlertController(title: "No Internet Connection", message: "Check Your Connection!", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }

    
    
    func readRow(row : Int)-> Dictionary<String, AnyObject> {
        let contact : AnyObject? = json[row]
        
        let collection = contact! as! Dictionary<String, AnyObject>
        return collection
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let row = readRow(indexPath.row)
        let name : String = row["name"] as! String
        let cont : String = row["date"] as! String
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "employCell")
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = cont
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        readData()
    }

}
