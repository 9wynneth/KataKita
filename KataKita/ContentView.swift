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
    
    @State private var selectedSegment = 0

    @Query private var items: [Item]

    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedSegment) {
                Text("AAC").tag(0)
                Text("BELAJAR").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 500)
            
            if selectedSegment == 0 {
                aacView()
            } else {
                PECSView()
                    .zIndex(1)
            }
            
            
        }
        .background(
            Color(hex: "BDD4CE", transparency: 1.0)        )
    }
    

}
enum ProfileSection : String, CaseIterable {
    case tweets = "aacView"
    case media = "PECSView"
    case likes = "Likes"
}






#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
