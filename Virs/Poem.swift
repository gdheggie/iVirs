//
//  Poem.swift
//  Virs
//
//  Created by Greg Heggie on 11/13/17.
//  Copyright © 2017 Greg Heggie. All rights reserved.
//

import Foundation

class Poem {
    var title: String
    var poem: String
    var poet: String
    var date: String
    var poemId: String
    var poetId: String
    var snapCount: Int
    var poetView: String
    
    init(){
        title = "huh"
        poem = "oh no"
        poet = "who"
        date = "when"
        poemId = "how"
        poetId = "whooo"
        poetView = "howww"
        snapCount = 5555555
    }
    
    init(_title: String, _poem: String, _poet: String, _date: String, _poemId: String, _poetId: String, _poetView: String, snaps: Int) {
        title = _title
        poem = _poem
        poet = _poet
        date = _date
        poemId = _poemId
        poetId = _poetId
        poetView = _poetView
        snapCount = snaps
    }
}
