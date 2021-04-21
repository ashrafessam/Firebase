//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 27/03/2021.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
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
        //home
        
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "unselectedHome")!, selectedImage: UIImage(named: "selectedHome")!, rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "unselectedSearch")!, selectedImage: UIImage(named: "selectedSearch")!)
        
        //add
        let plusNavController = templateNavController(unselectedImage: UIImage(named: "unselectedPlus")!, selectedImage: UIImage(named: "selectedPlus")!)
        
        //Favorite
        let favoriteNavController = templateNavController(unselectedImage: UIImage(named: "unselectedFavorite")!, selectedImage: UIImage(named: "selectedFavorite")!)
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavControlller = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavControlller.tabBarItem.image = UIImage(named: "unselectedUser")
        userProfileNavControlller.tabBarItem.selectedImage = UIImage(named: "selectedUser")
        
        tabBar.tintColor = .black
        
        
        viewControllers = [homeNavController, searchNavController, plusNavController, favoriteNavController ,userProfileNavControlller]
        
        
        //Modify Tabbar Insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
