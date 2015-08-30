//
//  ArrayInbox.swift
//  Manager
//
//  Created by ZoZy on 6/15/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import Foundation

class ArrayInbox {
    var title:String = "title"
    var sender: String = "sender"
    var device: String = "device"
    init (sender: String, device: String){
        self.title = sender + " want to borrow " + device
        self.device=device
        self.sender = sender
    }
}
