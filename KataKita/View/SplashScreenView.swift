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
    @AppStorage("activitied") private var activitied = false

    @State private var activitiesManager: ActivitiesManager
    @State private var boardManager: BoardManager
    
    @State private var scheduleManager: ScheduleManager
    @State private var stateManager: StateManager
    @State private var profileManager: ProfileViewModel

    // Track if the splash screen is visible
    @State private var isActive = true
    @State private var animationOpacity = 0.0
    @State private var animationScale: CGFloat = 0.8
    
    @State private var currentAsset: Int = 1
    @State private var showTransitionToMakkata: Bool = false
    @State private var showLine: Bool = false
    @State private var showDog: Bool = false
    @State private var showTail: Bool = false
    @State private var backgroundColor: Color = .white
    
    init(_ model: ModelContext) {
        self._activitiesManager = State(initialValue: ActivitiesManager(model))
        self._boardManager = State(initialValue: BoardManager(model))
        
        self._scheduleManager = State(initialValue: ScheduleManager())
        self._stateManager  = State(initialValue: StateManager())
        self._profileManager = State(initialValue: ProfileViewModel())
    }

    var body: some View {
        Group {
            if isActive {
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
                    if currentAsset == 1 {
                    
                    } else if currentAsset == 2 {
                        Image("m2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .transition(.opacity)
                            .padding(.top, 230)
                    } else if currentAsset == 3 {
                        Image("m3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .offset(x: showTransitionToMakkata ? -330 : 0) // Slide to the left
                            .animation(.easeIn(duration: 0.5), value: showTransitionToMakkata)
                            .padding(.top, 230)
                    }
                    
                    // Asset 4 (makkata1) stays until the end
                    if currentAsset >= 4 {
                        Image("makkata1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 800, height: 800)
                            .padding(.top, 180)
                    }
                    
                    // Asset line appearing from bottom to top of makkata1
                    if currentAsset >= 5 {
                        Image("line")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 80)
                            .offset(y: showLine ? 20 : 300) // Slide up animation
                            .animation(.easeInOut(duration: 1), value: showLine)
                    }
                    
                    if currentAsset == 6 {
                        Image("dog 1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .offset(y: showDog ? -100 : -50)
                            .animation(.easeInOut(duration: 1), value: showDog)
                    }

                    // Tail asset appears after dog1 and stays until the end
                    if currentAsset == 6 || currentAsset == 7 {
                        Image("tail")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .offset(y: showTail ? -280 : -280)
                            .animation(.easeInOut(duration: 1), value: showTail)
                            .padding(.leading,100)
                    }

                    // Asset dog2 appearing after dog1
                    if currentAsset == 7 {
                        Image("dog 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .offset(y: -100) // Dog2 stays in its final position
                    }
                }
                .onAppear {
                    animateSequence()
                }
            } else {
                // Main content view
                ContentView()
            }
        }
        .environment(self.activitiesManager)
        .environment(self.boardManager)
        .environment(self.scheduleManager)
        .environment(self.stateManager)
        .environment(self.profileManager)
        .onAppear {
            self.profileManager.load()
            self.scheduleManager.load()
            self.stateManager.load()
            
            if !self.boarded {
                self.boardManager.populate()
                self.boarded = true
            }
            self.boardManager.load()
            
            if !self.activitied {
                self.activitiesManager.populate()
                self.activitied = true
            }
            self.activitiesManager.load()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                self.isActive = false
            }
        }
    }
    private func animateSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.3)) {
                currentAsset = 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeIn(duration: 0.3)) {
                    currentAsset = 3
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        backgroundColor = Color(hex: "#C6DBD5", transparency: 1)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showTransitionToMakkata = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                currentAsset = 4 // Display `makkata1`
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentAsset = 5 // Display `line`
                                    showLine = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentAsset = 6 // Display `dog1`
                                        showDog = true
                                        showTail = true // Start showing the tail after dog1
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        currentAsset = 7 // Change to `dog2`
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
