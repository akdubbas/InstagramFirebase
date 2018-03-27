//
//  User.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/26/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
}

