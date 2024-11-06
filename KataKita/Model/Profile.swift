//
//  Profile.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 05/11/24.
//

import Foundation

class Profile: Codable {
    var name: String
    var gender: Bool
    
    init(name: String, gender: Bool) {
        self.name = name
        self.gender = gender
    }
}
