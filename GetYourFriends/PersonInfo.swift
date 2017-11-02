//
//  PersonInfo.swift
//  FriendsApp
//
//  Created by Jiyoon on 2017. 10. 27..
//  Copyright © 2017년 Jiyoon. All rights reserved.
//

import UIKit
import Foundation

class PersonInfo {
    var first_name: String
    var last_name: String
    var gender: String
    var email: String
    var phone: String
    var location: String
    var photo: UIImage?
    
    init(first_name: String, last_name: String, gender: String, email: String, phone: String, location: String, photo: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.gender = gender
        self.email = email
        self.phone = phone
        self.location = location
        
        let url = URL(string: photo)!
        let data = try? Data(contentsOf: url)
        
        self.photo = UIImage(data: data!)!
    }
    
    init(first_name: String, last_name: String, gender: String, email: String, phone: String, location: String, photo: UIImage) {
        self.first_name = first_name
        self.last_name = last_name
        self.gender = gender
        self.email = email
        self.phone = phone
        self.location = location
        self.photo = photo
    }
}

