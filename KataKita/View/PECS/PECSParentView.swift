//
//  PECSParentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSParentView: View {
    @Binding var cards: [[Card]]
    
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
                        ZStack {
                            CustomButton(
                                icon: resolveIcon(for: card.icon),
                                text: card.name,
                                width: .infinity,
                                height: .infinity,
                                font: 24,
                                iconWidth: 80,
                                iconHeight: 60,
                                bgColor: card.category.getColorString(),
                                bgTransparency: 0.65,
                                fontColor: "000000",
                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                            )
                            
                            CustomButton(
                                icon: "xmark",
                                text: "",
                                width: 50,
                                height: 50,
                                font: 24,
                                iconWidth: 20,
                                iconHeight: 20,
                                bgColor: "F47455",
                                bgTransparency: 1,
                                fontColor: "ffffff",
                                fontTransparency: 1.0,
                                cornerRadius: 25,
                                isSystemImage: true
                            ) {
                                cards[i].remove(at: j)
                            }
                            .offset(x: -5, y: 5)
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
