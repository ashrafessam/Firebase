//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 26/04/2021.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()){
        FirebaseDatabase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapchot) in

            guard let userDictionary = snapchot.value as? [String:Any] else {return}
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        } withCancel: { (error) in
            print("Failed to fetch user for post: ", error)
        }
    }
}
