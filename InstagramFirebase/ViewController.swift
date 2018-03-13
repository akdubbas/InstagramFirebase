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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let userNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()

    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoButton)
        photoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        setUpInputFields()
        
    }
    
    fileprivate func setUpInputFields()
    {
        let stackView = UIStackView(arrangedSubviews : [emailTextField,userNameTextField,passwordTextField,signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
            ])
        
        

    }

  


}

