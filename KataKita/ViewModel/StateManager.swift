//
//  StateManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 17/10/24.
//

import Foundation

// Mantau tanggal & Activity index
@Observable
class StateManager {
    private var date: Date {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(self.date, forKey: "date")
        }
    }
    var index: Int {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(self.index, forKey: "index")
        }
    }

    init(_ date: Date = .now, index: Int = 0) {
        self.date = date
        self.index = index
        self.compareDate()
    }
    
    func load() {
        let defaults = UserDefaults.standard
        self.date = defaults.object(forKey: "date") as? Date ?? self.date
        self.index = defaults.object(forKey: "index") as? Int ?? 0
    }
    
    private func compareDate() {
        if !Calendar.current.isDate(Date.now, equalTo: self.date, toGranularity: .day) {
            self.reset()
            self.date = Date.now
        }
    }
    
    func increment() {
        self.index += 1
    }
    
    func reset() {
        self.index = 0
    }
}
