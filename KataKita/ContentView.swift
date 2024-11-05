//
//  ContentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ScheduleManager.self) private var scheduleManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    
    @Query private var items: [Item]

    var body: some View {
        DailyActivityView()
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
