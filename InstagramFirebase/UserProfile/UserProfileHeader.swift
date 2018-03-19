//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/18/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader :UICollectionViewCell {
    
    //This appUser value will be set in UserProfileController.fetchUser method
    
    var appUser : AppUser? {
        didSet {
          setProfileImage()
            usernameLabel.text = appUser?.username
        }
    }
    
    let profileImageView : UIImageView = {
       let iv = UIImageView()
        return iv
    }()
    
    let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
       //button.tintColor = UIColor(white : 0,alpha : 0.1)
        return button
    }()
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white : 0,alpha : 0.2)
        return button
    }()
    let bookMarkButton : UIButton = {
        let button = UIButton(type:.system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white : 0,alpha : 0.2)
        return button
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel : UILabel = {
        let label = UILabel()
        label.text = "10\nposts"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        label.text = "10\nposts"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        label.text = "10\nposts"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12,paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
        setUpBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4,paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setUserStats()
        
        addSubview(editProfileButton)
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2,paddingLeft: 0, paddingBottom: 0, paddingRight: -15, width: 0, height: 34)
        
    }
    
    fileprivate func setUserStats()
    {
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12,paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setUpBottomToolbar()
    {
     
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0,paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    fileprivate func setProfileImage()
    {
        guard let url = appUser?.profileImageUrl else{
            return
        }
        guard let  imageUrl = URL(string : url) else {
            return
        }
        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response,error) in
            
            if let error = error {
                print("Error Fetching Image with error: ", error)
                return
            }
            
            guard let data = data else{
                return
            }
            let image = UIImage(data: data)
            
            //need to get on to main thread
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            
            
        }).resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
