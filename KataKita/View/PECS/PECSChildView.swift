//
//  PECSChildView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSChildView: View {
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let templateWidth = 1366.0
    let templateHeight = 1024.0
    
    var body: some View {
        HStack(spacing: 220) {
            ForEach(0..<5, id: \.self) { _ in
                //rectangle
                VStack (spacing: 5) {
                    Text("child")
                }
                .background(
                    Rectangle()
                        .fill(Color(hex: "D9D9D9", transparency: 0.4))
                        .frame(width: 180, height: 580)
                    
                )
                
            }
        }
        .frame(width: screenWidth * (1180 / templateWidth), height: screenHeight * (700 / templateHeight))
        .padding()

    }
}

#Preview {
    PECSChildView()
}
