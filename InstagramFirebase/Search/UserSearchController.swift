//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/27/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit

class UserSearchController : UICollectionViewController
{
    
    let searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Username"
        sb.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: -8, width: 0, height: 0)
    }
}
