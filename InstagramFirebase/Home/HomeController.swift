//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 26/04/2021.
//

import UIKit
import Firebase



class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = SharePhotoController.updateFeedNotificationName
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: name, object: nil)
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed(){
        handleRefreshControl()
    }
    
    @objc fileprivate func handleRefreshControl(){
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        posts.removeAll()
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        FirebaseDatabase.Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapchot) in
            
            
            guard let userIdsDictionary = snapchot.value as? [String: Any] else { return }
            userIdsDictionary.forEach { (key, value) in
                Database.fetchUserWithUid(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            }
        } withCancel: { (error) in
            print("Failed to fetch following posts", error)
        }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts(){
        guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUid(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User){
        self.posts.removeAll()
        let ref = FirebaseDatabase.Database.database().reference().child("posts").child(user.uid)
        ref.observe(.value) { (snapchot) in
            
            self.collectionView.refreshControl?.endRefreshing()
            guard let dictionaries = snapchot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            }
            self.collectionView.reloadData()
        } withCancel: { (error) in
            print("Failed to fetch posts: ", error)
        }
    }
    
    fileprivate func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "instagram"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "selectedHome")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(HandleCamera))
    }
    
    @objc fileprivate func HandleCamera(){
        print(123)
        
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8  //user profile imageView
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
}
