//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/13/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let photoButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        return button
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let userNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()

    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoButton)
        photoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingBottom: nil, paddingLeft: nil, paddingRight: nil, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setUpInputFields()
        
    }
    
    fileprivate func setUpInputFields()
    {
        let stackView = UIStackView(arrangedSubviews : [emailTextField,userNameTextField,passwordTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
    
        stackView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 40, paddingRight: -40,width : 0,height : 200)
        

    }
}

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor?,left : NSLayoutXAxisAnchor?,bottom : NSLayoutYAxisAnchor?, right : NSLayoutXAxisAnchor?, paddingTop : CGFloat?,paddingBottom : CGFloat?,paddingLeft : CGFloat?, paddingRight : CGFloat?, width : CGFloat,height : CGFloat){
        
        //Applies to every constraint calling this function
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top, let paddingTop =  paddingTop{
         self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left, let paddingLeft = paddingLeft{
         self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right, let paddingRight = paddingRight {
         self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let bottom = bottom, let paddingBottom = paddingBottom {
         self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0 {
         self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0{
         self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

