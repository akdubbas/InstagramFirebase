//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController : userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = UIColor.black
        viewControllers = [navController]
    }
}
