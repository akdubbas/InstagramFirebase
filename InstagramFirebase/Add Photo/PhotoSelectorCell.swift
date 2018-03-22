//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/21/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit

class PhotoSelectorCell : UICollectionViewCell
{
    let photoImageView : UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imv.backgroundColor = UIColor.lightGray
        return imv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        backgroundColor = UIColor.brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
