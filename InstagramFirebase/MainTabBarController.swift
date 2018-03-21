//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController : UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
                return
            }
        }
        setUpViewControllers()
 }
    
    func setUpViewControllers()
    {
        let homeController =  templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),selectedImage: #imageLiteral(resourceName: "home_selected"))
        let searchController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        let plusPhotoController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        let likePhotoController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_unselected"))
        
       
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        //use command+ctrl+e to edit all var at once
        let userNavController = UINavigationController(rootViewController : userProfileController)
        userNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = UIColor.black
        viewControllers = [homeController,searchController,plusPhotoController,likePhotoController,userNavController]
        //viewControllers = [navController,UIViewController()]

    }
    
    fileprivate func templateNavController(unselectedImage : UIImage, selectedImage: UIImage) -> UINavigationController
    {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
