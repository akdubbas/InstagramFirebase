//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/19/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginController : UIViewController
{
    let logoContainerView : UIView = {
        
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
        
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleInputChanges), for: .editingChanged)
        return textField
    }()

    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleInputChanges), for: .editingChanged)
        return textField
    }()
    
    let loginInButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type : .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have account?  ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor :UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setInputFields()
    
    }
    @objc func handleSignUp()
    {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc func handleLogin()
    {
        
        guard let email = emailTextField.text,let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, signInerror) in
            if let error = signInerror {
                print("Error while sign in..", error)
                
                
            }
            print("User Signed in successfully")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{
                return
            }
            mainTabBarController.setUpViewControllers()
            self.dismiss(animated: true, completion: nil)
           
        }
    }
    
    fileprivate func setInputFields()
    {
        let stackView  = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginInButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left:view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: 0, height: 140)
        
    }
    
    @objc func handleInputChanges()
    {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if(isFormValid)
        {
            loginInButton.isEnabled = true
            loginInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else{
            loginInButton.isEnabled = false
            loginInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
}
