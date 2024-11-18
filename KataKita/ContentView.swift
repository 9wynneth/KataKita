//
//  ContentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Picker("Select View", selection: $selectedSegment) {
                Text("JADWAL").tag(2)
                Text("AAC").tag(0)
                Text("PECS").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 500)
            
            if self.selectedSegment == 0 {
                BetterAACView()
            } else if self.selectedSegment == 1 {
                PECSView()
            } else {
                DailyActivityView()
            }
        }
        .frame(alignment: .topLeading)
        .background(Color(hex: "BDD4CE", transparency: 1.0).ignoresSafeArea())
    }
}

