//
//  MyDatabase.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class Defined {
    static let defaults = UserDefaults.standard
    static let storage = Storage.storage().reference()
    static let ref = Database.database().reference()
    static let formatter = NumberFormatter()
}

struct keys {
    static let id = "id"
    static let avatar = "avatar"
    static let email = "email"
   
}


