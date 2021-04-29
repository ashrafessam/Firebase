//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 22/03/2021.
//

import UIKit
import Firebase
class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusButtonPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "AddPhoto")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusButtonPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusButtonPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            plusButtonPhoto.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            plusButtonPhoto.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusButtonPhoto.layer.cornerRadius = plusButtonPhoto.frame.width/2
        plusButtonPhoto.layer.masksToBounds = true
        plusButtonPhoto.layer.borderColor = UIColor.black.cgColor
        plusButtonPhoto.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
            usernameTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else {
            signUpButton.isUserInteractionEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton =  {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0  else {return}
        guard let password = passwordTextField.text, password.count > 0  else {return}
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            
            print("Successfully created user", user?.user.uid ?? "")
            
            guard let image = self.plusButtonPhoto.imageView?.image else {return}
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            let storage = FirebaseStorage.Storage.storage()
            let storageRef = storage.reference().child("profile_images").child("\(fileName)")
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil{
                    print(error ?? "Failed to upload data in the uploadImages object there was an error:", error!)
                    return
                }
                print("Successfully uploaded image to database")
                
                storageRef.downloadURL { (url, error) in
                    if let err = error {
                        print("Error", err)
                        return
                    }
                    guard let uid = user?.user.uid else { return }
                    guard let url = url else { return }
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": "\(url)"] as Dictionary<String,Any>
                    let values = [uid:dictionaryValues]
                    
                    FirebaseDatabase.Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                        if let error = err {
                            print("Failed to save user info into db: ", error)
                            return
                        }
                        print("Successfully saved user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                        
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237) ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccountButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: -20, paddingRight: 40, width: 0, height: 0)
        
        
        view.backgroundColor = .white
        view.addSubview(plusButtonPhoto)
        plusButtonPhoto.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        plusButtonPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInputFields()
    }
    
    fileprivate func setupInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(top: plusButtonPhoto.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
}



