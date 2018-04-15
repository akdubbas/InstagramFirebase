//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 4/15/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

