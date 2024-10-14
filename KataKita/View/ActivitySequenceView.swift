//
//  ActivitySequenceView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//

import SwiftUI

struct ActivitySequenceView: View {
    var steps: [String]
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @Binding var selectedActivity: String
    @State private var buttonDoneCliked: Bool = false

    
    var body: some View {
        let items = Array(1...10).map { "\($0)"}
        
        VStack {
            HStack {
                Spacer()
                CustomButtonSide(icon: "hand.thumbsup.fill", text: "SELESAI", width: Int(screenWidth * (150 / 1210.0)), height: Int(screenHeight * (50 / 834.0)), font: Int(screenWidth * (15 / 1210.0)),iconWidth: Int(screenWidth * (15 / 1210.0)) , iconHeight: Int(screenHeight * (15 / 834.0)), bgColor: "CFF0C8",
                                 bgTransparency: buttonDoneCliked ? 1.0 : 0.0, fontColor: "000000", fontTransparency: 1.0, cornerRadius: 20, strokeColor: "CFF0C8", action:
                                    {
                    buttonDoneCliked.toggle()
                }
                )
                .padding()
                .padding(.top,10)
                .padding(.trailing,24)
            }
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))]) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        ActivityCard(
                            icon: "ball",
                            nomor: "\(index + 1)",
                            text: steps[index],
                            width: Int(screenWidth * (180 / 1210.0)), height: Int(screenWidth * (180 / 1210.0)),
                            font: Int(screenWidth * (15 / 1210.0)), iconWidth: Int(screenWidth * (50 / 1210.0)), iconHeight: Int(screenHeight * (50 / 834.0)),
                            bgColor: "FFFFFF", bgTransparency: 1.0,
                            fontColor: "000000", fontTransparency: 1.0,
                            cornerRadius: 20, isSystemImage: false
                        )
                        .padding(8)
                        
                    }

                    Spacer()
                }
                .padding()
                
                .onAppear{
                    print(UIScreen.main.bounds.width)
                    print(UIScreen.main.bounds.height)
                    
                }
                
            }.frame(width: CGFloat(screenWidth) * (900 / 1210), height: CGFloat(screenHeight) * (780 / 1210))
        }
        
    }
}

//#Preview {
//    ActivitySequenceView(steps: [
//        "Ambil sikat gigi",
//        "Ambil pasta gigi",
//        "Tuangkan pasta gigi",
//        "Mulai menyikat gigi",
//        "Kumur air",
//        "Selesai"
//    ])
//}
