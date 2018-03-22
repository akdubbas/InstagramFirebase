//
//  Post.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/22/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
