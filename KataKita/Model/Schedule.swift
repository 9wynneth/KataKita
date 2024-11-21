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
    
    func localizedString() -> String {
        let locale = Locale.current.languageCode // Fetch the current language code
        switch locale {
        case "id": // Indonesian localization
            switch self {
            case .SUNDAY: return "Hari Minggu"
            case .MONDAY: return "Hari Senin"
            case .TUESDAY: return "Hari Selasa"
            case .WEDNESDAY: return "Hari Rabu"
            case .THURSDAY: return "Hari Kamis"
            case .FRIDAY: return "Hari Jumat"
            case .SATURDAY: return "Hari Sabtu"
            }
        case "zh": // Chinese localization
            switch self {
            case .SUNDAY: return "星期日"
            case .MONDAY: return "星期一"
            case .TUESDAY: return "星期二"
            case .WEDNESDAY: return "星期三"
            case .THURSDAY: return "星期四"
            case .FRIDAY: return "星期五"
            case .SATURDAY: return "星期六"
            }
        default: // Default to English
            return self.rawValue.capitalized // Capitalize the raw value for English
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
