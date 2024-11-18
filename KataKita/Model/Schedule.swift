//
//  Schedule.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 10/10/24.
//

import Foundation

/// Enum with inner value (Associated value)
enum Day: String, Equatable {
    case SUNDAY
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    
    func toString() -> String {
        switch self {
            case .SUNDAY: return "Minggu"
            case .MONDAY: return "Senin"
            case .TUESDAY: return "Selasa"
            case .WEDNESDAY: return "Rabu"
            case .THURSDAY: return "Kamis"
            case .FRIDAY: return "Jumat"
            case .SATURDAY: return "Sabtu"
        }
    }
}

struct Schedule: Codable {
    var sunday: [UUID]
    var monday: [UUID]
    var tuesday: [UUID]
    var wednesday: [UUID]
    var thursday: [UUID]
    var friday: [UUID]
    var saturday: [UUID]
    
    init() {
        self.sunday = []
        self.monday = []
        self.tuesday = []
        self.wednesday = []
        self.thursday = []
        self.friday = []
        self.saturday = []
    }
}
