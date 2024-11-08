//
//  SplashScreenView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/11/24.
//

import SwiftUI

struct SplashScreen: View {
    // Track if the splash screen is visible
    @State private var isActive = true
    @State private var animationOpacity = 0.0
    @State private var animationScale: CGFloat = 0.8

    var body: some View {
        if isActive {
            VStack {
                Text("m")
                    .font(.custom("Dacht", size: 75))
                    .opacity(isActive ? 1.0 : 0.0) // Show "m" immediately
                    .foregroundColor(Color(hex: "013D5A", transparency: 1.0))
            }
            
            VStack {
                Image("logo") // Replace with your logo or splash screen image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(animationOpacity)
                    .scaleEffect(animationScale)
                    .onAppear {
                        // Animate opacity and scale for a smooth effect
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.animationOpacity = 1.0
                            self.animationScale = 1.0
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = false
                    }
                }
            }
        } else {
            // Main content view
            ContentView()
        }
    }
}

