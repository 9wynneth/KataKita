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
    @Environment(SecurityManager.self) private var securityManager
    
    @Query private var items: [Item]
    @State private var selectedSegment = 0
    

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedSegment) {
                Text("AAC").tag(0)
                Text("BELAJAR").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 500)
            
            if selectedSegment == 0 {
                BetterAACView()
            } else {
                PECSView()
                    .zIndex(1)
            }
            
            
        }
        .background(
            Color(hex: "BDD4CE", transparency: 1.0)
        )
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
