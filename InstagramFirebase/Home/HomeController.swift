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
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        fetchPosts()
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
