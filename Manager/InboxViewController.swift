//
//  InboxViewController.swift
//  Manager
//
//  Created by ZoZy on 6/15/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedCellIndexPath: NSIndexPath?
    var json = Array<AnyObject>()
    let SelectedCellHeight: CGFloat = 80
    let UnselectedCellHeight: CGFloat = 50
    override func viewDidLoad() {
        var row1:ArrayInbox = ArrayInbox(sender: "Chuong",device: "iPhone5")
        var row2:ArrayInbox = ArrayInbox(sender: "test1",device: "Macbook")
        json.append(row1)
        json.append(row2)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                self.selectedCellIndexPath = nil
            } else {
                self.selectedCellIndexPath = indexPath
            }
        } else {
            selectedCellIndexPath = indexPath
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InboxCustomCell
        cell.setselected()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! InboxCustomCell
        cell.setdeselected()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let selectedCellIndexPath = selectedCellIndexPath {
            if selectedCellIndexPath == indexPath {
                return SelectedCellHeight
            }
        }
        
        return UnselectedCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxCell") as! InboxCustomCell
        let row:ArrayInbox = json[indexPath.row] as! ArrayInbox
        cell.title.text = row.title
        cell.sender = row.sender
        cell.device = row.device
        return cell
    }
}
