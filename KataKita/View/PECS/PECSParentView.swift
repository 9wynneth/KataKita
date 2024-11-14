//
//  PECSParentView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSParentView: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(PECSViewModel.self) private var pecsViewModel
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    @State private var showDeleteAlert = false
    @State private var cardToDelete: (Int, Int)? = nil // To track which card to delete
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(Array(self.pecsViewModel.cards.enumerated()), id: \.offset) { i, column in
                //rectangle
                VStack(spacing: 10) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        ZStack(alignment: .topTrailing) {
                            PECSParentCard(
                                card,
                                (self.width, self.height)
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
                        RoundedRectangle(cornerRadius: 10)
                            .fill(getBackgroundColor(for: column))
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
                        self.pecsViewModel.cards[cardToDelete.0].remove(at: cardToDelete.1)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func getBackgroundColor(for column: [Card]) -> Color {
        // Example logic: Check if there's at least one card, and take its category color
        if let firstCard = column.first {
            return Color(hex: firstCard.category.getColorString(), transparency: 0.4)
        } else {
            // Default background color if no cards exist in the column
            return Color(hex: "D9D9D9", transparency: 0.4)
        }
    }
    
    private func genderHandler(_ name: String) -> String {
        if AllAssets.shared.genderAssets.contains(name) {
            if self.viewModel.userProfile.gender {
                return "GIRL_"
            }
            return "BOY_"
        }
        return ""
    }
}

struct PECSParentCard: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat

    init(_ card: Card, _ size: (CGFloat, CGFloat)) {
        self.card = card
        self.width = size.0
        self.height = size.1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if case let .image(data) = self.card.type {
                Image(uiImage: UIImage(data: data) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: (self.width - 20) / 3, height: (self.width - 20) / 3)
            } else if case let .icon(icon) = self.card.type {
                Icon(icon, ((self.width - 20) / 3, (self.width - 20) / 3))
            } else {
                Color.clear
                    .frame(width: (self.width - 20) / 3, height: (self.width - 20) / 3)
            }
            
            if ["Hitam", "Cokelat", "Oranye", "Merah", "Ungu", "Pink", "Biru", "Hijau", "Kuning", "Putih"].contains(card.name) {
                TextContent(
                    text: card.name,
                    size: 14,
                    color: "000000",
                    transparency: 0,
                    weight: "medium"
                )
            } else {
                TextContent(
                    text: card.name,
                    size: 14,
                    color: "000000",
                    transparency: 1,
                    weight: "medium"
                )
                .padding(.horizontal)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .frame(width: self.width - 20, height: (self.height - 60) / 5)
        .background(
            Group {
                if case let .color(color) = self.card.type {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color(hex: color, transparency: 1))
                } else {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color(hex: self.card.category.getColorString(), transparency: 1))
                }
            }
        )
    }
}
