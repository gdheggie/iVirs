//
//  Poet.swift
//  Virs
//
//  Created by Greg Heggie on 11/13/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import Foundation

class Poet {
    var username: String
    var userId: String
    var userIcon: String
    var poems: [String]
    var snappedPoems: [String]
    
    init() {
        username = "..."
        userId = "huh"
        userIcon = "whooo"
        poems = ["non"]
        snappedPoems = ["nah"]
    }
    
    //initializing class
    init(_username: String, _userId: String, _userIcon: String, _poems: [String], _snappedPoems: [String]){
        username = _username
        userId = _userId
        userIcon = _userIcon
        poems = _poems
        snappedPoems = _snappedPoems
    }
}
