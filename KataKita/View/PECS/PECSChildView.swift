//
//  PECSChildView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSChildView: View {
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
    PECSChildView(Binding.constant([[],[],[],[],[]]))
}
