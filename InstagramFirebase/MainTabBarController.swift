//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 27/03/2021.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
    }
    
    func setupViewControllers(){
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = UIImage(named: "unselectedUser")
        navController.tabBarItem.selectedImage = UIImage(named: "selectedUser")
        
        tabBar.tintColor = .black
        
        
        viewControllers = [navController, UIViewController()]

    }
}
