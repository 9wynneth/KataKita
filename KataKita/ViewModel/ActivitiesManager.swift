//
//  ActivitiesManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 11/10/24.
//

import Foundation

// CRUD for Activity list inside AddDailyActivity Feature

@Observable
class ActivitiesManager {
    var activities : [Activity]
    
    init(_ activities: [Activity] = []) {
        self.activities = activities
    }
    
    func addActivity(_ activity: Activity) {
        self.activities.append(activity)
    }
    
    func removeActivity(_ index: Int) {
        if(activities.count > index) {
            self.activities.remove(at: index)
        }
    }
    
    // Update existing activity
        func updateActivity(_ updatedActivity: Activity) {
            if let index = activities.firstIndex(where: { $0.id == updatedActivity.id }) {
                activities[index] = updatedActivity
            }
        }
    
}
