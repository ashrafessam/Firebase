//
//  Post.swift
//  InstagramFirebase
//
//  Created by Ashraf Essam on 25/04/2021.
//

import UIKit

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
