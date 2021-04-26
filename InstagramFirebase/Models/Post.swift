//
//  Post.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 25/04/2021.
//

import UIKit

struct Post {
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
