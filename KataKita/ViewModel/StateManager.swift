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
    var date: Date
    var index: Int
    
    init(_ date: Date = .now, index: Int = 0) {
        self.date = date
        self.index = index
    }
    
    func increment() {
        self.index += 1
    }
    
    func compareDate() -> Bool {
        return Calendar.current.isDate(Date.now, equalTo: self.date, toGranularity: .day)
    }
    func reset() {
        self.index = 0
    }
}
