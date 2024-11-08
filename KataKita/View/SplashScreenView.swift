//
//  SplashScreenView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/11/24.
//

import SwiftData
import SwiftUI

struct SplashScreen: View {
    @AppStorage("boarded") private var boarded = false
    
    @State private var boardManager: BoardManager
    @State private var profileManager: ProfileViewModel

    // Track if the splash screen is visible
    @State private var isActive = true
    @State private var animationOpacity = 0.0
    @State private var animationScale: CGFloat = 0.8
    
    init(_ model: ModelContext) {
        self._boardManager = State(initialValue: BoardManager(model))
        self._profileManager = State(initialValue: ProfileViewModel())
    }

    var body: some View {
        Group {
            if isActive {
                VStack {
                    Text("m")
                        .font(.custom("Dacht", size: 75))
                        .opacity(isActive ? 1.0 : 0.0)  // Show "m" immediately
                        .foregroundColor(
                            Color(hex: "013D5A", transparency: 1.0))
                }

                VStack {
                    Image("logo")  // Replace with your logo or splash screen image
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
            } else {
                // Main content view
                ContentView()
            }
        }
        .environment(self.boardManager)
        .environment(self.profileManager)
        .onAppear {
            let defaults = UserDefaults.standard
            
            if let raw = defaults.object(forKey: "user") as? Data {
                guard let user = try? JSONDecoder().decode(UserProfile.self, from: raw) else {
                    return
                }
                self.profileManager.userProfile = user
            } else {
                self.profileManager.userProfile = UserProfile()
            }
            
            if !self.boarded {
                self.boardManager.populate()
                self.boarded = true
            }
            self.boardManager.load()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.isActive = false
            }
        }
    }
}
