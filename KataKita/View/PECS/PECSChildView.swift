//
//  PECSChildView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct PECSChildView: View {
    @Environment(ProfileViewModel.self) private var viewModel
    
    @Binding var state: DraggingState
    @Binding var cards: [[Card]]
    let f: (Card?) -> Void

    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    @State private var draggingIndex: Int? = nil

    //MARK: Button color
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    init(_ cards: Binding<[[Card]]>, _ state: Binding<DraggingState>, f: @escaping (Card?) -> Void) {
        self._cards = cards
        self._state = state
        self.f = f
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(Array(self.cards.enumerated()), id: \.offset) { i, column in
                VStack(spacing: 10) {
                    ForEach(Array(column.enumerated()), id: \.offset) { j, card in
                        PECSChildCard(
                            self.$state,
                            card,
                            (self.width, self.height),
                            card.isImageType ? nil : resolveIcon(for: "\(self.genderHandler(card.icon))\(card.icon)")
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
                            .fill(getBackgroundColor(for: column))
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
    @State private var opacity = 1.0
    @State private var dragging = false
    
    @Binding var state: DraggingState
    
    let card: Card
    let width: CGFloat
    let height: CGFloat
    let icon: String?
    let f: (Card?) -> Void

    init(_ state: Binding<DraggingState>, _ card: Card, _ size: (CGFloat, CGFloat), _ icon: String?, f: @escaping (Card?) -> Void) {
        self._state = state
        self.card = card
        self.width = size.0
        self.height = size.1
        self.icon = icon
        self.f = f
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if self.card.isImageType {
                Image(uiImage: (UIImage(named: self.card.icon) ?? UIImage()))
                    .resizable()
                    .scaledToFit()
                    .frame(width: (self.width - 20) / 3, height: (self.width - 20) / 3)
            } else if let icon = self.icon {
                Image(icon)
                    .antialiased(true)
                    .resizable()
                    .scaledToFit()
                    .frame(width: (self.width - 20) / 3, height: (self.width - 20) / 3)
            } else {
                Color.clear
                    .frame(width: (self.width - 20) / 3, height: (self.width - 20) / 3)
            }
            
            TextContent(
                text: self.card.name,
                size: 14,
                color: "000000",
                transparency: 1,
                weight: "medium"
            )
            .padding(.horizontal)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: self.width - 20, height: (self.height - 60) / 5)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: self.card.color ?? self.card.category.getColorString(), transparency: 1))
        )
        .offset(x: self.offsetCurr.x, y: self.offsetCurr.y)
        .gesture(self.makeDragGesture())
        .zIndex(self.dragging ? 2 : 1)
        .opacity(self.opacity)
        .onChange(of: self.state) {
            if self.dragging {
                if self.state == .disappearing {
                    withAnimation(.linear(duration: 0.15)) {
                        self.opacity = 0
                    } completion: {
                        self.offsetCurr = .zero
                        self.offsetLast = .zero
                        self.opacity = 1
                        self.state = .idle
                        self.dragging = false
                        self.f(nil)
                    }
                } else if self.state == .reverting {
                    withAnimation {
                        self.offsetCurr = .zero
                        self.offsetLast = .zero
                    } completion: {
                        self.state = .idle
                        self.dragging = false
                        self.f(nil)
                    }
                }
            }
        }
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
    }
}
