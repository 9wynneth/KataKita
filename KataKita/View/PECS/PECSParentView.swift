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
        VStack {
            HStack(spacing: 50) {
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
        }
    }
}

#Preview {
    PECSParentView(Binding.constant([[],[],[],[],[]]))
}
