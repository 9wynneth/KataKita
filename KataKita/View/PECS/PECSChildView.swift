//
//  PECSChildView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSChildView: View {
    @Binding var cards: [[Card]]
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    init(_ cards: Binding<[[Card]]>) {
        self._cards = cards
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(Array(self.cards.enumerated()), id: \.offset) { i, column in
                //rectangle
                VStack(spacing: 10) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        CustomButton(
                            icon: resolveIcon(for: card.icon),
                            text: card.name,
                            width: (self.height - 60) / 5,
                            height: (self.height - 60) / 5,
                            font: 30,
                            iconWidth: Int((self.width - 20) / 3),
                            iconHeight: Int ((self.width - 20) / 3),
                            bgColor: card.category.getColorString(),
                            bgTransparency: 0.65,
                            fontColor: "000000",
                            fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                        )
                        .draggable(card)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(getBackgroundColor(for: column))
                            .onAppear {
                                self.width = geometry.frame(in: .global).width
                                self.height = geometry.frame(in: .global).height
                                
                                print(self.width, self.height)
                            }
                    }
                )
             
            }
        }
        .padding(20)
    }
    func getBackgroundColor(for column: [Card]) -> Color {
            // Example logic: Check if there's at least one card, and take its category color
            if let firstCard = column.first {
                return Color(hex: firstCard.category.getColorString(), transparency: 0.4)
            } else {
                // Default background color if no cards exist in the column
                return Color(hex: "D9D9D9", transparency: 0.4)
            }
        }
}

#Preview {
    PECSChildView(Binding.constant([[],[],[],[],[]]))
}
