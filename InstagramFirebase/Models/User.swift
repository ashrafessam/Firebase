//
//  User.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 26/04/2021.
//

import UIKit    

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
