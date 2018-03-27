//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController : UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
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
    
    /*Method belongs to UITabBarControllerDelegate, If we want to show the custom ViewController when UITabBarItem is selected, return false to disable all the view Controllers from showing up
     Loop through the tabBar items to disable specific view controllers
     */
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        //for adding photos - disable the plus photo button
        if index == 2 {
            let collectionFlowLayout = UICollectionViewFlowLayout()
            
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: collectionFlowLayout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
        }
        return true
    }
    
    func setUpViewControllers()
    {
        let homeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
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
        
        guard let items = tabBar.items else{
            return
        }
        for item in items {
            //push tabBar items 4 pixels below from tabBar
            //Adjust the aspect ratio by setting bottom anchor to -4
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        

    }
    
    fileprivate func templateNavController(unselectedImage : UIImage, selectedImage: UIImage,rootViewController : UIViewController = UIViewController()) -> UINavigationController
    {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
