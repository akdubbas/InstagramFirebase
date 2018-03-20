//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Amith Dubbasi on 3/13/18.
//  Copyright © 2018 iDiscover. All rights reserved.
//

import UIKit
import Firebase
import  SVProgressHUD
class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let photoButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.addTarget(self, action:#selector(handleUploadPhoto) , for: .touchUpInside)
        return button
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
    
    let userNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
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
    
    let signUpButton : UIButton = {
        let button = UIButton(type : .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccount : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Sign In!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(gobackToLoginPage), for: .touchUpInside)
        return button
    }()
    
    @objc func gobackToLoginPage()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleInputChanges()
    {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && userNameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if(isFormValid)
        {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc func handleSignUp(sender : UIButton)
    {
        SVProgressHUD.show(withStatus: "Logging in")
        guard let email = emailTextField.text,!email.isEmpty else {
            return
        }
        guard let password = passwordTextField.text,!password.isEmpty else{
            return
        }
        guard let username = userNameTextField.text, !username.isEmpty else {
            return
        }
    
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if(error != nil)
            {
                print(error!)
            }
          print("User Registered Successfully: ", user?.uid ?? "")
           
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            guard let profileImage = self.photoButton.imageView?.image else {
                return
            }
            guard let uploadPhoto = UIImageJPEGRepresentation(profileImage, 0.3) else {
                return
            }
            storageRef.putData(uploadPhoto, metadata: nil, completion: { (metadata, error) in
                if let error = error
                {
                    print(error)
                    return
                }
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else{
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                let userNameValues = ["username":username, "profileImageUrl":imageUrl]
                let values = [uid:userNameValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    
                    if let error = error {
                        print("Failed to save user Info in db: ", error)
                    }
                    print("Successfully saved user in to Database")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{
                        return
                    }
                    mainTabBarController.setUpViewControllers()
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
            })
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(photoButton)
        photoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40,paddingLeft: nil, paddingBottom: nil, paddingRight: nil, width: 140, height: 140)
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setUpInputFields()
        
        view.addSubview(alreadyHaveAccount)
        alreadyHaveAccount.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        
    }
    
    fileprivate func setUpInputFields()
    {
        let stackView = UIStackView(arrangedSubviews : [emailTextField,userNameTextField,passwordTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
    
        stackView.anchor(top: photoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: -40,width : 0,height : 200)
        

    }
    
    @objc func handleUploadPhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editeditedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editeditedImage
        }
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let profileImageView = selectedImageFromPicker {
            photoButton.setImage(profileImageView.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        photoButton.layer.cornerRadius = photoButton.frame.width/2
        photoButton.layer.masksToBounds = true
        photoButton.layer.borderColor = UIColor.black.cgColor
        photoButton.layer.borderWidth = 2
        dismiss(animated: true, completion: nil)
        
    }
}

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor?,left : NSLayoutXAxisAnchor?,bottom : NSLayoutYAxisAnchor?, right : NSLayoutXAxisAnchor?, paddingTop : CGFloat?,paddingLeft : CGFloat?,paddingBottom : CGFloat?, paddingRight : CGFloat?, width : CGFloat,height : CGFloat){
        
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

