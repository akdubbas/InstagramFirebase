//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/17/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase


class UserProfileController : UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    var appUser : AppUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
    }
    
    
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





















