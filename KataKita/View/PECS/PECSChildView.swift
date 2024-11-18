//
//  PECSChildView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSChildView: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(PECSViewModel.self) private var pecsViewModel

    @Binding var cards: [[Card]]
    
    let f: (Card?) -> Void
    

    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    @State private var draggingIndex: Int? = nil

    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    init(_ cards: Binding<[[Card]]>, f: @escaping (Card?) -> Void) {
        self._cards = cards
        self.f = f
    }
    
    var backgrounds: [Color] {
            var a: [Color] = []
            for col in self.pecsViewModel.cards {
                a.append(getBackgroundColor(for: col))
            }
            return a
        }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(Array(self.cards.enumerated()), id: \.offset) { i, column in
                VStack(spacing: 10) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        PECSChildCard(
                            card,
                            (self.width, self.height)
                        ) { dragging in
                            self.f(dragging)
                            if dragging != nil {
                                self.draggingIndex = i
                            } else {
                                self.draggingIndex = nil
                            }
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(self.backgrounds[safe: i] ?? Color(hex: "D9D9D9", transparency: 0.4))
                            .onAppear {
                                self.width = geometry.frame(in: .global).width
                                self.height = geometry.frame(in: .global).height
                            }
                    }
                )
                .zIndex(self.draggingIndex == i ? 2 : 1)
            }
        }
        .padding(20)
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

struct PECSChildCard: View {
    @State private var offsetCurr: CGPoint = .zero
    @State private var offsetLast: CGSize = .zero
    @State private var dragging = false
    
    let card: Card
    let width: CGFloat
    let height: CGFloat
    let f: (Card?) -> Void

    init(_ card: Card, _ size: (CGFloat, CGFloat), f: @escaping (Card?) -> Void) {
        self.card = card
        self.width = size.0
        self.height = size.1
        self.f = f
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
        .offset(x: self.offsetCurr.x, y: self.offsetCurr.y)
        .gesture(self.makeDragGesture())
        .zIndex(self.dragging ? 2 : 1)
    }
    
    private func makeDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if !self.dragging {
                    self.dragging = true
                    self.f(self.card)
                }
                let diff = CGPoint(
                    x: value.translation.width - self.offsetLast.width,
                    y: value.translation.height - self.offsetLast.height
                )
                self.offsetCurr = CGPoint(
                    x: self.offsetCurr.x + diff.x,
                    y: self.offsetCurr.y + diff.y
                )
                self.offsetLast = value.translation
            }
            .onEnded { _ in
                self.offsetCurr = .zero
                self.offsetLast = .zero
                self.dragging = false
                self.f(nil)
            }
    }
}
