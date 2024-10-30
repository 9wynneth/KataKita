//
//  AACView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 30/10/24.
//


import SwiftUI

struct AACView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let templateWidth = 1366.0
    let templateHeight = 1024.0
    
    var body: some View {
        VStack {
            HStack(spacing:screenWidth * (30/templateWidth)) {
                Spacer()
                //textbox
                ZStack {
                    HStack {
                        
                    }
                    .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (150/templateHeight))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "FFFFFF", transparency: 1.0))
                    )
                    Spacer()
                    HStack {
                        Spacer()
                        //delete button
                        CustomButton(
                            icon: "delete",
                            width: Int(screenWidth * (90/templateWidth)),
                            height: Int(screenHeight * (140/templateHeight)),
                            font: 40,
                            iconWidth: Int(screenWidth * (50/templateWidth)),
                            iconHeight: Int(screenHeight * (50/templateHeight)),
                            bgColor: "#ffffff",
                            bgTransparency: 0.01,
                            fontColor: "#ffffff",
                            fontTransparency: 0,
                            cornerRadius: 20,
                            isSystemImage: false,
                            action: {
                                //                            if !selectedButton.isEmpty {
                                //                                selectedButton.removeLast()
                                //                                speechSynthesizer.stopSpeaking(at: .immediate)
                                //                            }
                            }
                        )
                    }
                    .frame(width: screenWidth * (1100/templateWidth) , height: screenHeight * (150/templateHeight))
                    
                }
                .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (110/templateHeight))
                
                //trash button
                CustomButton(
                    icon: "trash",
                    width: Int(screenWidth * (150/templateWidth)),
                    height: Int(screenHeight * (150/templateHeight)),
                    font: 40,
                    iconWidth: Int(screenWidth * (50/templateWidth)),
                    iconHeight: Int(screenHeight * (50/templateHeight)),
                    bgColor: "FFFFFF",
                    bgTransparency: 1.0,
                    fontColor: "000000",
                    fontTransparency: 1.0,
                    cornerRadius: 20,
                    isSystemImage: false,
                    action:{
                        //                            if !selectedButton.isEmpty {
                        //                                selectedButton.removeAll()
                        //                                speechSynthesizer.stopSpeaking(at: .immediate)
                        //                            }
                    }
                )
                Spacer()
            }
            .padding(.top,screenHeight * (50/templateHeight))
            
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 30)
                .frame(width: screenWidth * (1370/templateWidth), height: screenHeight * (720/templateHeight))
                .padding(.bottom, screenWidth * (-20/templateWidth))
                .foregroundColor(Color(hex: "ffffff", transparency: 1.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "BDD4CE", transparency: 1.0))
        .ignoresSafeArea(.all)
        .onAppear{
            print(UIScreen.main.bounds.width)
            print(UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    AACView()
}