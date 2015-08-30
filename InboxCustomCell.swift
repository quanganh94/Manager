//
//  InboxCustomCell.swift
//  Manager
//
//  Created by ZoZy on 6/15/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class InboxCustomCell: UITableViewCell {

    var sender = String()
    var device = String ()
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var btnReject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setselected(){
        btnAccept.hidden=false
        btnReject.hidden=false
    }
    func setdeselected(){
        btnAccept.hidden=true
        btnReject.hidden=true
    }
    
    @IBAction func accepted(sender: AnyObject) {
    }
    
    @IBAction func rejected(sender: AnyObject) {
    }

}
