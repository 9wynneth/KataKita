//
//  AddCardModalView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct AddCardModalView: View {
    //MARK: Viewport Size
    @Binding var cards: [[Card]]
    
    @State private var pecsCards: [[Card]]? = nil
    @State private var addingCard: Int? = nil
    @State private var addingBoard = false
    
    @Environment(BoardManager.self) private var boardManager
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let colorCards: [Card] = [
        Card(name: "Hitam", icon: "", category: .ADJECTIVE, isColorType: true, color: "000000"),
        Card(name: "Cokelat", icon: "", category: .ADJECTIVE, isColorType: true, color: "835737"),
        Card(name: "Oranye", icon: "", category: .ADJECTIVE, isColorType: true, color: "E9AE50"),
        Card(name: "Merah", icon: "", category: .ADJECTIVE, isColorType: true, color: "E54646"),
        Card(name: "Ungu", icon: "", category: .ADJECTIVE, isColorType: true, color: "B378D8"),
        Card(name: "Pink", icon: "", category: .ADJECTIVE, isColorType: true, color: "EDB0DC"),
        Card(name: "Biru", icon: "", category: .ADJECTIVE, isColorType: true, color: "889AE4"),
        Card(name: "Hijau", icon: "", category: .ADJECTIVE, isColorType: true, color: "B7D273"),
        Card(name: "Kuning", icon: "", category: .ADJECTIVE, isColorType: true, color: "EFDB76"),
        Card(name: "Putih", icon: "", category: .ADJECTIVE, isColorType: true, color: "F2EFDE"),
    ]
    
    @State private var id = UUID()
    //    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode // For dismissing the sheet
    
    
    init(_ cards: Binding<[[Card]]>) {
        self._cards = cards
    }
    
    var selectedBoard: Board? {
        if let board = boardManager.boards.first(where: { $0.id == id }) {
            return board
        }
        
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Navigation && Actions
            HStack (spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(boardManager.boards.sorted { $0.name.lowercased() < $1.name.lowercased() }) { board in
                        ZStack(alignment: .trailing) {
                            HStack {
                                TextContent(
                                    text: board.name.uppercased(),
                                    size: 15,
                                    color: "00000",
                                    transparency: 1.0,
                                    weight: "medium"
                                )
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                Spacer(minLength: 60)
                            }
                            .opacity(id == board.id ? 1 : 0)
                            .frame(maxHeight: .infinity)
                            if let icon = board.icon {
                                Image(icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50)
                            } else {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50)
                            }
                            
                        }
                        .padding(.horizontal, 15)
                        .frame(width: id == board.id ? 165 : 80, alignment: .trailing)
                        .background(
                            Rectangle()
                                .fill(Color(hex: id == board.id ? "FFFFFF" : "EFEFEF", transparency: 1))
                                .clipShape(
                                    .rect(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10)
                                )
                        )
                        .animation(.spring(duration: 0.25), value: id == board.id)
                        .onTapGesture {
                            id = board.id
                        }
                    }
                }
                .frame(height: 75)
                Spacer()
            }
            .padding(.top, 15)
            
            // MARK: BOARD
            VStack {
                HStack(alignment: .top, spacing: 25) {
                    if let board = self.selectedBoard {
                        AACBoardView(board, cards: self.$pecsCards)
                    }
                    
                    VStack(spacing: screenHeight * 0.02) {
                        ForEach(Array(colorCards.enumerated()), id: \.offset) {index, card in
                            Button {
                                self.cardHandler(card)
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: card.color ?? "FFFFFF", transparency: 1))
                                    .frame(width: 120, height: screenHeight * 0.05)
                            }
                        }
                    }
                }
            }
            .padding(.top, 45)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 50, trailing: 0))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .clipShape(
                        .rect(topLeadingRadius: 45, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 45)
                    )
                    .frame(width: screenWidth)
                    .ignoresSafeArea()
            )
        }
        .padding(EdgeInsets(top: 30, leading: 45, bottom: 40, trailing: 45))
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .onAppear {
            self.pecsCards = self.cards
            if let firstBoard = boardManager.boards.first {
                id = firstBoard.id
            }
        }
        .onChange(of: id) {
            boardManager.selectId(id)
        }
        .onChange(of: self.pecsCards) {
            if let cards = self.pecsCards {
                self.cards = cards
            }
        }
    }
    
    private func cardHandler(_ card: Card) {
        if self.cards.count >= 2 {
            if let pos = self.getCardPos(card) {
                self.cards[pos.0].remove(at: pos.1)
            } else {
                if card.category == .CORE {
                    if self.cards[0].count < 5 {
                        self.cards[0].append(card)
                    }
                } else if let index = self.cards.firstIndex(where: {
                    $0.contains(where: { $0.category == card.category })
                }) {
                    if self.cards[index].count < 5 {
                        self.cards[index].append(card)
                    }
                } else if let index = self.cards[1...].firstIndex(where: {
                    $0.isEmpty
                }) {
                    if self.cards[index].count < 5 {
                        self.cards[index].append(card)
                    }
                }
            }
            self.pecsCards = self.cards
        }
    }
    private func getCardPos(_ card: Card) -> (Int, Int)? {
        for (colIndex, col) in self.cards.enumerated() {
            for (rowIndex, row) in col.enumerated() {
                if row.id == card.id {
                    return (colIndex, rowIndex)
                }
            }
        }

        return nil
    }
}


#Preview {
    AddCardModalView(Binding.constant([[Card]]()))
}
