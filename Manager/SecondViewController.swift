//
//  SecondViewController.swift
//  Manager
//
//  Created by ZoZy on 5/26/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
   
    var json =  Array<AnyObject>()
    var username: String = ""
    var detailTitle: String = ""
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       readData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func readData(){
//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            let url=NSURL(string:"http://zozy.me/devicemanager/employee.php")
//            let allContactsData=NSData(contentsOfURL:url!)
//            var allContacts: AnyObject! = NSJSONSerialization.JSONObjectWithData(allContactsData!, options: NSJSONReadingOptions(0), error: nil)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.json = allContacts as Array<AnyObject>
//                self.tableView.reloadData()
//            })
//        })
//    }
    
    func readData(){
        self.tableIndicator.startAnimating()

        let myUrl = NSURL(string: "http://zozy.me/devicemanager/employee.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        detailTitle = selectedCell.textLabel!.text!
        username = selectedCell.detailTextLabel!.text!
        performSegueWithIdentifier("viewEmploy", sender: tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let row = readRow(indexPath.row)
        let name : String = row["fullname"] as! String
        let cont : String = row["username"] as! String
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier: "employCell")
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = cont
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var EmployVC:EmployeeViewController = segue.destinationViewController as! EmployeeViewController
            EmployVC.userid = self.username
            EmployVC.titleTxt = self.detailTitle
    }


}

