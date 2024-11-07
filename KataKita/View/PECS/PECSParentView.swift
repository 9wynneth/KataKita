//
//  PECSParentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSParentView: View {
    @Binding var cards: [[Card]]
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    @State private var showDeleteAlert = false
    @State private var cardToDelete: (Int, Int)? = nil // To track which card to delete
    
    
    init(_ cards: Binding<[[Card]]>) {
        self._cards = cards
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(Array(self.cards.enumerated()), id: \.offset) { i, column in
                //rectangle
                VStack(spacing: 10) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        ZStack(alignment: .topTrailing) {
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
                                fontTransparency: 1.0,
                                cornerRadius: 13,
                                isSystemImage: false
                            )
                            
                            CustomButton(
                                icon: "xmark",
                                text: "",
                                width: 30,
                                height: 30,
                                font: 15,
                                iconWidth: 15,
                                iconHeight: 15,
                                bgColor: "F47455",
                                bgTransparency: 1,
                                fontColor: "ffffff",
                                fontTransparency: 1.0,
                                cornerRadius: 25,
                                isSystemImage: true
                            ) {
//                                cards[i].remove(at: j)
                                self.cardToDelete = (i, j)
                                self.showDeleteAlert = true
                            }
                            .offset(x: -5, y: 5)
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color(hex: "D9D9D9", transparency: 0.4))
                            .onAppear {
                                self.width = geometry.frame(in: .global).width
                                self.height = geometry.frame(in: .global).height
                            }
                    }
                )
            }
        }
        .padding(20)
        .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Card"),
                        message: Text("Are you sure you want to delete this card?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let cardToDelete = self.cardToDelete {
                                self.cards[cardToDelete.0].remove(at: cardToDelete.1) 
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
}

#Preview {
    PECSParentView(Binding.constant([[],[],[],[],[]]))
}
