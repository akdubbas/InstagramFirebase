//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/22/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController{
    
    var selectedImage : UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
   var imageView : UIImageView = {
       let imv = UIImageView()
        imv.backgroundColor = UIColor.white
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    var textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.backgroundColor = UIColor.white
        return tv
    }()
    
    /*override var prefersStatusBarHidden: Bool {
        return true
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShareAction))
        setUpInputComponents()
    }
    
    @objc func handleShareAction()
    {
        guard let caption  = textView.text, caption.characters.count > 0 else{
            return
        }
        guard let pickedImage = selectedImage else {
            return
        }
        guard let data = UIImageJPEGRepresentation(pickedImage, 0.5) else {
            return
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let fileName = UUID().uuidString
        Storage.storage().reference().child("posts").child(fileName).putData(data, metadata: nil) { (metadata, error) in
            if let err = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image to Firebase Storage ",err)
                return
            }
            
            guard let imageUrl  = metadata?.downloadURL()?.absoluteString else{
                return
            }
            print("Successfully Uploaded Image with url ",imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl : imageUrl)
            
        }
        
    }
    fileprivate func saveToDatabaseWithImageUrl(imageUrl : String)
    {
        guard let postImage = self.selectedImage else{return}
        guard let caption = self.textView.text else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        //childByAutoId method creates new node each time when user sends a new post
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl" : imageUrl,"caption" : caption,"imageWidth" : postImage.size.width,"imageHeight" : postImage.size.height] as [String : Any]
        ref.updateChildValues(values) { (error, ref) in
            if let err = error {
                print("Error has occured while uploading image to Database",err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    fileprivate func setUpInputComponents()
    {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        self.view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    
        
    }
}
