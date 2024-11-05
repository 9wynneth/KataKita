//
//  PECSView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSView: View {

    @Environment(\.dismiss) var dismiss
    
    
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let templateWidth = 1366.0
    let templateHeight = 1024.0
    
    @State private var position = CGSize.zero
    @State private var scale: CGFloat = 1.0 // State to track scale for pinch gesture
//    @State private var dragAmount: CGPoint?
    @State private var dragAmounts: [UUID: CGPoint] = [:] // Dictionary for each card's drag amount
    @State var toggleOn =  false

    @State var isAskPassword =  false
    @EnvironmentObject var securityManager: SecurityManager

    @State private var isAddCard = false

    var body: some View {
        ZStack {
            VStack(spacing:20) {
                VStack {

                        //part 2
                        HStack (spacing: 30) {
                            Spacer()
                            //whiteboard
                            VStack {
                                ZStack {
                                    PECSChildView()
                                        .opacity(toggleOn ? 0 : 1)
                                        .rotation3DEffect(
                                            .degrees(toggleOn ? 180 : 0),
                                            axis: (x: 0.0, y: 1.0, z: 0.0)
                                        )
                                        .animation(.easeInOut(duration: 0.6), value: toggleOn)
                                    
                                    PECSParentView()
                                        .opacity(toggleOn ? 1 : 0)
                                        .rotation3DEffect(
                                            .degrees(toggleOn ? 0 : -180),
                                            axis: (x: 0.0, y: 1.0, z: 0.0)
                                        )
                                        .animation(.easeInOut(duration: 0.6), value: toggleOn)
                                    
                                    
                                }
                                
                            }
                            .frame(width: screenWidth * (1180 / templateWidth), height: screenHeight * (700 / templateHeight))
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(hex: "F7F5F0", transparency: 1.0))
                            )
                            
                            //toggle and button
                            VStack (spacing: 20) {
                                //toggle
                                VStack {
                                    ZStack {
                                        Capsule()
                                            .frame(width:80,height:44)
                                            .foregroundColor(Color.gray)
                                        ZStack{
                                            Circle()
                                                .frame(width:40, height:40)
                                                .foregroundColor(.white)
                                            Image(systemName: toggleOn ?  "figure.and.child.holdinghands" : "figure.child.and.lock.open")
                                        }
                                        .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                                        .offset(x:toggleOn ? 18 : -18)
                                        .padding(24)
                                        .animation(.spring())
                                    }
                                    .onTapGesture {
                                        isAskPassword = true
//                                        if securityManager.isCorrect == true {
//                                            self.toggleOn.toggle()
//
//                                        }
                                    }
                                }
                                .animation(.default)
                                
                                
                                //nti masukin asset refresh
                                
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
                                            dismiss()
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
                                
                                Spacer()
                            }
                            .frame(height: screenHeight * (700 / templateHeight))
                            
                            Spacer()
                        }
                        .padding()
                    
                    //part 3
                    HStack {
                        VStack {
                            
                            

                        }
                        .frame(width: screenWidth * (1150 / templateWidth), height: screenHeight * (150 / templateHeight))
                        .background(
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(hex: "ffffff", transparency: 1.0))
                        )
                        

                        Spacer()
                        CustomButton(
                            icon: "trash",
                            width: 100,
                            height: 100,
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
                    .frame(width: screenWidth * (1280 / templateWidth)) // Set frame for the HStack
                    .padding()

                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "BDD4CE", transparency: 0))
            .navigationBarBackButtonHidden(true)
            .onTapGesture{
                isAskPassword = false
            }
            .padding(.top,-30)

            
            if isAskPassword {
                SecurityView()
            }
            if isAddCard{
                

            }
        }
        .onChange(of: securityManager.isCorrect) { newValue in
                    if newValue {
                        // Password is correct; toggle and reset values
                        toggleOn.toggle()
                        isAskPassword = false
                        securityManager.isCorrect = false 
                    }
                }
        
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
}
