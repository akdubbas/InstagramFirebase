//
//  PhotoSelectorHeader.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/21/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit


class PhotoSelectorHeader : UICollectionViewCell
{
    var latestImageView : UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imv.backgroundColor = UIColor.lightGray
        return imv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(latestImageView)
        latestImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
