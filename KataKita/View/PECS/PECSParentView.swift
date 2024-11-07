//
//  PECSParentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSParentView: View {
    @Binding var cards: [[Card]]
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    init(_ cards: Binding<[[Card]]>) {
        self._cards = cards
    }
    

    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(self.cards.enumerated()), id: \.offset) { i, column in
                //rectangle
                VStack (spacing: 5) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        if j <= 5 {
                            CustomButton(
                                icon: resolveIcon(for: card.icon),
                                text: card.name,
                                width: screenWidth * 0.09,
                                height: screenWidth * 0.09,
                                font: 38,
                                iconWidth: 80,
                                iconHeight: 80,
                                bgColor: card.category.getColorString(),
                                bgTransparency: 0.65,
                                fontColor: "000000",
                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                            )
                            .padding(1)
                        }
                    }
                    
                Spacer()
                }
                .padding(.top, 12)
                .frame(width: screenWidth * 0.15, height: screenHeight*0.65)
                .background(
                    Rectangle()
                        .fill(Color(hex: "D9D9D9", transparency: 0.4))
                )
            }
        }
        .padding(20)
    }
}

#Preview {
    PECSParentView(Binding.constant([[],[],[],[],[]]))
}
