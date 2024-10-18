//
//  Activity.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 10/10/24.
//

import Foundation
import UIKit

struct Step {
    var image: String
    var description: String
}

struct Activity: Identifiable {
    var id: UUID
    var name: String
    var image: String // Optional
    var ruangan: Ruangan
    var sequence: [Step]   // Activities consist of many steps (Sequence)!
    var isCompleted: Bool?
}

struct Ruangan: Identifiable {
    let id: UUID
    let name: String
    
}