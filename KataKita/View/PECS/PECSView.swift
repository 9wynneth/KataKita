//
//  PECSView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSView: View {
    @Environment(PECSViewModel.self) var pECSViewModel
    @Environment(SecurityManager.self) var securityManager
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    //MARK: Button color
    let colors: [Color] = [
        .black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow,
    ]

    let templateWidth = 1366.0
    let templateHeight = 1024.0

    @State private var cards: [[Card]] = [[], [], [], [], []]
    @State private var position = CGSize.zero
    @State private var scale: CGFloat = 1.0  // State to track scale for pinch gesture
    //    @State private var dragAmount: CGPoint?
    @State private var dragAmounts: [UUID: CGPoint] = [:]  // Dictionary for each card's drag amount
    @State var toggleOn = false

    @State var isAskPassword = false

    @State private var isAddCard = false

    var body: some View {
        VStack(alignment: .leading, spacing: 45) {
            //part 2
            HStack(alignment: .top, spacing: 20) {
                //whiteboard
                ZStack {
                    PECSChildView(self.$cards)
                        .opacity(toggleOn ? 0 : 1)
                        .rotation3DEffect(
                            .degrees(toggleOn ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(
                            .easeInOut(duration: 0.6), value: toggleOn)

                    PECSParentView(self.$cards)
                        .opacity(toggleOn ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(toggleOn ? 0 : -180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(
                            .easeInOut(duration: 0.6), value: toggleOn)
                }
                .frame(
                    maxWidth: .infinity
                )
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "F7F5F0", transparency: 1.0))
                )

                //MARK: toggle and button
                VStack(spacing: 20) {
                    //MARK: toggle
                    ZStack {
                        Capsule()
                            .frame(width: 80, height: 44)
                            .foregroundColor(Color.gray)
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Image(
                                systemName: toggleOn
                                    ? "figure.and.child.holdinghands"
                                    : "figure.child.and.lock.open")
                        }
                        .shadow(
                            color: .black.opacity(0.14), radius: 4,
                            x: 0, y: 2
                        )
                        .offset(x: toggleOn ? 18 : -18)
                        .padding(24)
                        .animation(.spring(duration: 0.25), value: toggleOn)
                    }
                    .onTapGesture {
                        if !toggleOn {
                            isAskPassword = true
                        } else {
                            toggleOn.toggle()
                        }
                    }
                    .animation(.spring(duration: 0.25), value: toggleOn)

                    //TODO: nanti masukin asset refresh

                    if toggleOn {
                        CustomButton(
                            icon: "arrow.clockwise",
                            width: 85,
                            height: 85,
                            font: 40,
                            iconWidth: 40,
                            iconHeight: 40,
                            bgColor: "F7F5F0",
                            bgTransparency: 1.0,
                            fontColor: "696767",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            action: {
                                //                                        MARK: dismiss()
                            }
                        )
                        CustomButton(
                            icon: "plus.rectangle.fill.on.rectangle.fill",
                            width: 85,
                            height: 85,
                            font: 40,
                            iconWidth: 40,
                            iconHeight: 40,
                            bgColor: "ffffff",
                            bgTransparency: 1.0,
                            fontColor: "696767",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            action: {
                                isAddCard = true
                            }

                        )
                    }
                }
                .frame(width: 80)
            }
            
            //part 3
            HStack(spacing: 20) {
                HStack {
                    Color.clear
                        .frame(height: 120)
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "ffffff", transparency: 1.0))
                )

                CustomButton(
                    icon: "trash",
                    width: 80,
                    height: 80,
                    font: 60,
                    iconWidth: 50,
                    iconHeight: 50,
                    bgColor: "ffffff",
                    bgTransparency: 1.0,
                    fontColor: "#696767",
                    fontTransparency: 1.0,
                    cornerRadius: 20
                )
            }
            .padding()
        }
        .padding(EdgeInsets(top: 0, leading: 45, bottom: 30, trailing: 45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "BDD4CE", transparency: 1))
        .navigationBarBackButtonHidden(true)
        .onTapGesture{
            isAskPassword = false
        }
        .padding(.top,-30)
        .overlay(
            Group {
                if isAskPassword {
                    SecurityView()
                } else if isAddCard {
                    //TODO: Create Logic Here
                    EmptyView()
                } else {
                    EmptyView()
                }
            }
        )
        .sheet(isPresented: $isAddCard) {
            ZStack {
                Color.clear
                    .background(BackgroundClearView())
                    .onTapGesture {
                        isAddCard = false
                    }
                AddCardModalView(self.$cards)
            }
            .frame(width: screenWidth)
        }
        .onTapGesture {
            isAskPassword = false
        }
        .onChange(of: securityManager.isCorrect) {
            if securityManager.isCorrect {
                // Password is correct; toggle and reset values
                toggleOn.toggle()
                isAskPassword = false
                securityManager.isCorrect = false
            }
        }
        .onChange(of: self.cards, initial: true) {
            print(self.cards)
            self.pECSViewModel.cards = self.cards
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isAddCard) {
            Color.yellow.opacity(0)
                .background(BackgroundClearView())
                .onTapGesture {
                    isAddCard = false
                }
            AddCardModalView(self.$cards)
                .frame(width: screenWidth , height: screenHeight * 0.85)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, screenWidth * 0.125)
                .background(Color.clear)
                .ignoresSafeArea(.all, edges: .bottom)
                .padding(.bottom, -50)
        }
        .ignoresSafeArea(.all)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: self.cards, initial: true) {
            print(self.cards)
            self.pECSViewModel.cards = self.cards
        }
    }
}
struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    struct BackgroundClearView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}

//extension PECSView: DropDelegate {
//    func performDrop(info: DropInfo) -> Bool {
//        guard let item = info.itemProviders(for: ["public.text"]).first else { return false }
//
//        item.loadObject(ofClass: String.self) { (string, error) in
//            if let text = string as? String {
//                print("Dropped text: \(text)") // Handle the dropped text
//                // Here you can update your model or UI as needed
//            }
//        }
//        return true
//    }
//}
#Preview {
    PECSView()
        .environment(SecurityManager())
        .environment(PECSViewModel())
}
