//
//  ProfileViewController.swift
//  Manager
//
//  Created by ZoZy on 5/27/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit
import QuartzCore

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var alertlbl: UILabel!
    @IBOutlet weak var fullname: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableIndicator: UIActivityIndicatorView!
    var userid: String = ""
    var json = Array<AnyObject>()
    override func viewDidLoad() {
        userid = NSUserDefaults.standardUserDefaults().objectForKey("userid")! as! String
        var name: String = NSUserDefaults.standardUserDefaults().objectForKey("fullname")! as! String
        
        self.fullname.text = name
        
        self.username.text = userid
        
        alertlbl.text = "0"
    }
    
    
    
    @IBAction func logout(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userid")
        self.performSegueWithIdentifier("Logout", sender: self)

    }
    
    func readData(){
        self.tableIndicator.startAnimating()

        let myUrl = NSURL(string: "http://zozy.me/devicemanager/owning.php");
        let request = NSMutableURLRequest(URL:myUrl!)
        let postString = "user=" + self.userid
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
        let name : String = row["Device"] as! String
        let cont : String = row["date"] as! String
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "employCell")
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = cont
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        checkInbox()
        readData()
    }

    func checkInbox(){
        let myUrl = NSURL(string: "http://zozy.me/devicemanager/inbox.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        // Compose a query string
        let postString = "user="+self.userid+"&request=count"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            if(error == nil){
                // do stuff in background queue
                let respond:String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
                
                // when ready to update model/UI dispatch that to main queue
                dispatch_async(dispatch_get_main_queue()) {
                    self.alertlbl.text = respond
                }
            }
        }
    }
}
