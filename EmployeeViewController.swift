//
//  EmployeeViewController.swift
//  Manager
//
//  Created by ZoZy on 5/27/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableIndicator: UIActivityIndicatorView!
    var userid: String = ""
    var titleTxt: String = ""
    var json = Array<AnyObject>()
    var detailTitle: String = ""
    override func viewDidLoad() {
        self.title=titleTxt;
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
                self.presentViewController(alertView, animated: true, completion: nil)            }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        detailTitle = selectedCell.textLabel!.text!
        performSegueWithIdentifier("employ2device", sender: tableView)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="employ2device"){
            var DeviceVC:DeviceViewController = segue.destinationViewController as! DeviceViewController
            DeviceVC.userid = self.userid
            DeviceVC.nav_title = self.detailTitle
            DeviceVC.user_title = self.title!
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        readData()
    }
}
