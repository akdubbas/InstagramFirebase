//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/18/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


//This is the Whole User Profile Header for UserProfileController(CollectionView) which contains profile image and user name, User stats like(Posts,followers,following), edit profile, and a stack view at the bottom of the header which contians List view, Grid view and Bookmarks

class UserProfileHeader :UICollectionViewCell {
    
    //This appUser value will be set in UserProfileController.fetchUser method
    
    var appUser : AppUser? {
        didSet {
          
            usernameLabel.text = appUser?.username
            guard let url = appUser?.profileImageUrl else{
                return
            }
            self.profileImageView.loadImage(urlString: url)
        }
    }
    
    let profileImageView : CustomImageView = {
       let iv = CustomImageView()
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
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor :UIColor.lightGray,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12) ]))
        label.attributedText = attributedText
        
        
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "100\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor :UIColor.lightGray,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12) ]))
        label.attributedText = attributedText
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "67\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor :UIColor.lightGray,NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 12) ]))
        label.attributedText = attributedText
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
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2,paddingLeft: 15, paddingBottom: 0, paddingRight: -20, width: 0, height: 34)
        
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
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
     
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0,paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
