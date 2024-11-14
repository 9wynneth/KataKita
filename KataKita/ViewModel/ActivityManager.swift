//
//  ActivityManager.swift
//  KataKita
//
//  Created by Alvito Dwi Heldy Muhammad on 11/10/24.

import SwiftUI
import SwiftData

// CRUD for Activity : Editing image, name, sequence

@Observable
class ActivityManager {
    var activity: Activity

    init(_ activity: Activity = Activity(name: "new activity", sequence: [])) {
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

    func setName(_ name: String) {
        self.activity.name = name
    }

    func setType(_ type: ActivityType?) {
        self.activity.type = type
    }

    func setStep(_ updatedStep: Step, at index: Int) {
        if self.activity.sequence.indices.contains(index) {
            self.activity.sequence[index] = updatedStep
        }
    }
    func setStepDescription(description: String, at index: Int) {
        if self.activity.sequence.indices.contains(index) {
            self.activity.sequence[index].description = description
        }
    }
    func setStepType(_ type: ActivityType?, at index: Int) {
        if self.activity.sequence.indices.contains(index) {
            self.activity.sequence[index].type = type
        }
    }

    func resetSteps() {
        self.activity.sequence.removeAll()
    }
}
