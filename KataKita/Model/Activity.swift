//
//  Activity.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 10/10/24.
//

import Foundation
import UIKit
import SwiftData

struct Step: Codable {
    var type: ActivityType?
    var description: String
}

@Model
class Activity: Identifiable {
    var id: UUID
    var name: String
    var type: ActivityType?
    var sequence: [Step]
    
    init(name: String, type: ActivityType? = nil, sequence: [Step]) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.sequence = sequence
    }
}

enum ActivityType: Codable, Equatable {
    case icon(String)
    case image(Data)
    
    static func == (lhs: ActivityType, rhs: ActivityType) -> Bool {
        switch (lhs, rhs) {
            case (.icon(_), .icon(_)): return true
            case (.image(_), .image(_)): return true
            default: return false
        }
    }
}
