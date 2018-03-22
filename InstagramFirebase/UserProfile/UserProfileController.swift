//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class UserProfileController : UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    var appUser : AppUser?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setUpLogoutButton()
        fetchPosts()
        
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                //print("Key \(key), Value: \(value)")
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
        
    }
    fileprivate func setUpLogoutButton()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogoutButton))
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    //Horizontal Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    //Header for CollectionView Cell
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.appUser = self.appUser
        
        //not correct
        //header.addSubView(UIImageView())
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    fileprivate func fetchUser()
    {
        guard let userid = Auth.auth().currentUser?.uid else{
            return
        }
    Database.database().reference().child("users").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
            
        guard let dictionary = snapshot.value as? [String : Any] else{
            return
        }
        
        self.appUser = AppUser(dictionary: dictionary)
        self.navigationItem.title = self.appUser?.username
        self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to fetch User")
        }
        
    }
    
    @objc func handleLogoutButton()
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        let logOutAction: UIAlertAction = UIAlertAction(title: "Log Out",style: .destructive) { action -> Void in
            do{
            try Auth.auth().signOut()
                
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
                
            }
            catch let signOutErr{
                print("Failed to SignOut",signOutErr)
            }
            
        }
        actionSheetController.addAction(logOutAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
}


struct AppUser {
    
    let username : String?
    let profileImageUrl : String?
    
    init(dictionary : [String : Any])
    {
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}





















