//
//  ContentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(ScheduleManager.self) private var scheduleManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(SecurityManager.self) private var securityManager
    @Environment(BoardManager.self) private var boardManager

    @Query private var items: [Item]
    @State private var selectedSegment = 0
    
    @State private var cards: [[Card]] = [[], [], [], [], []]
    @State private var droppedCards: [Card] = []
    @State private var deletedCards: [Card] = []

    var body: some View {
        VStack(spacing: 30) {
            Picker("Select View", selection: $selectedSegment) {
                Text("AAC").tag(0)
                Text("BELAJAR").tag(1)
//                Text("JADWAL").tag(2)

            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 500)
            
            if self.selectedSegment == 0 {
                BetterAACView()
            } else if self.selectedSegment == 1 {
                PECSView(droppedCards: $droppedCards, deletedCards: $deletedCards)
            } else {
                DailyActivityView()
            }
        }
        .frame(alignment: .topLeading)
        .background(
            Color(hex: "BDD4CE", transparency: 1.0)
                .ignoresSafeArea()
        )
    }
}

