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
                        Text(card.name)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Rectangle()
                        .fill(Color(hex: "D9D9D9", transparency: 0.4))
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()

    }
}

#Preview {
    PECSChildView(Binding.constant([[],[],[],[],[]]))
}
