//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/25/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit


public class CustomImageView : UIImageView
{
    var lastURLUsedToLoadImage: String?
    
    public func loadImage(urlString: String) {
        print("Loading image...")
        
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
