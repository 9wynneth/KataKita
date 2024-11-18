//
//  ScheduleManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 11/10/24.
//

import Foundation

// Managing Schedule Data (schedule per day in a week)

@Observable
class ScheduleManager {
    var schedule: Schedule {
        didSet {
            print(schedule)
            guard let data = try? JSONEncoder().encode(self.schedule) else {
                return
            }
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "schedule")
        }
    }
    
    init() {
        self.schedule = Schedule()
    }
    
    func load() {
        let defaults = UserDefaults.standard
        if let raw = defaults.object(forKey: "schedule") as? Data {
            guard let schedule = try? JSONDecoder().decode(Schedule.self, from: raw) else {
                return
            }
            self.schedule = schedule
        } else {
            self.schedule = Schedule()
        }
    }
    
    func addActivity(_ id: UUID, day: Day) {
        if case .SUNDAY = day {
            self.schedule.sunday.append(id)
        } else if case .MONDAY = day {
            self.schedule.monday.append(id)
        } else if case .TUESDAY = day {
            self.schedule.tuesday.append(id)
        } else if case .WEDNESDAY = day {
            self.schedule.wednesday.append(id)
        } else if case .THURSDAY = day {
            self.schedule.thursday.append(id)
        } else if case .FRIDAY = day {
            self.schedule.friday.append(id)
        } else if case .SATURDAY = day {
            self.schedule.saturday.append(id)
        }
    }
    
    func removeActivity(_ index: Int, day: Day) {
        if case .SUNDAY = day {
            self.schedule.sunday.remove(at: index)
        } else if case .MONDAY = day {
            self.schedule.monday.remove(at: index)
        } else if case .TUESDAY = day {
            self.schedule.tuesday.remove(at: index)
        } else if case .WEDNESDAY = day {
            self.schedule.wednesday.remove(at: index)
        } else if case .THURSDAY = day {
            self.schedule.thursday.remove(at: index)
        } else if case .FRIDAY = day {
            self.schedule.friday.remove(at: index)
        } else if case .SATURDAY = day {
            self.schedule.saturday.remove(at: index)
        }
    }
    
    func removeActivities(day: Day) {
        if case .SUNDAY = day {
            self.schedule.sunday.removeAll()
        } else if case .MONDAY = day {
            self.schedule.monday.removeAll()
        } else if case .TUESDAY = day {
            self.schedule.tuesday.removeAll()
        } else if case .WEDNESDAY = day {
            self.schedule.wednesday.removeAll()
        } else if case .THURSDAY = day {
            self.schedule.thursday.removeAll()
        } else if case .FRIDAY = day {
            self.schedule.friday.removeAll()
        } else if case .SATURDAY = day {
            self.schedule.saturday.removeAll()
        }
    }
}

