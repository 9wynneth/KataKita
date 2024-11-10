//
//  ActivityManager.swift
//  KataKita
//
//  Created by Alvito Dwi Heldy Muhammad on 11/10/24.

import Foundation
import UIKit


// CRUD for Activity : Editing image, name, sequence

@Observable
class ActivityManager {
    var activity: Activity
    
    init(_ activity: Activity = Activity(id: UUID(), name: "new activity", image: "", ruangan: Ruangan(id: UUID(), name: ""), sequence: [])) {
        self.activity = activity
    }
    
    var steps: [Step] {
        return activity.sequence
    }

    func addStep(_ step: Step) {
        self.activity.sequence.append(step)
    }

    func removeStep(_ index: Int) {
        if self.activity.sequence.count > index {
            self.activity.sequence.remove(at: index)
        }
    }
    
    func setName(name: String) {
        self.activity.name = name
    }
    
    func setImage(image: String) {
        self.activity.image = image
    }
 
    func resetSteps() {
        activity.sequence.removeAll() 
    }
}

