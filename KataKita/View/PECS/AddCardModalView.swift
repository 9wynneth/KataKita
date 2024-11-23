//
//  AddCardModalView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct AddCardModalView: View {
    @Environment(\.presentationMode) private var presentationMode // For dismissing the sheet
    @Environment(BoardManager.self) private var boardManager
    @Environment(PECSViewModel.self) private var pecsViewModel

    @State private var id = UUID()
    @State private var addingCard: Int? = nil
    @State private var addingBoard = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let colorCards: [Card] = [
        Card(name: "Hitam", category: .ADJECTIVE, type: .color("000000")),
        Card(name: "Cokelat", category: .ADJECTIVE, type: .color("835737")),
        Card(name: "Oranye", category: .ADJECTIVE, type: .color("E9AE50")),
        Card(name: "Merah", category: .ADJECTIVE, type: .color("E54646")),
        Card(name: "Ungu", category: .ADJECTIVE, type: .color("B378D8")),
        Card(name: "Pink", category: .ADJECTIVE, type: .color("EDB0DC")),
        Card(name: "Biru", category: .ADJECTIVE, type: .color("889AE4")),
        Card(name: "Hijau", category: .ADJECTIVE, type: .color("B7D273")),
        Card(name: "Kuning", category: .ADJECTIVE, type: .color("EFDB76")),
        Card(name: "Putih", category: .ADJECTIVE, type: .color("F2EFDE")),
    ]
    
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
                                Image(resolveIcon(for: icon))
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
                        AACBoardView(board, pecs: true)
                    }
                    
                    VStack(spacing: screenHeight * 0.02) {
                        ForEach(Array(colorCards.enumerated()), id: \.offset) {index, card in
                            Button {
                                self.pecsViewModel.cardHandler(card)
                            } label: {
                                Group {
                                    if case let .color(color) = card.type {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: color, transparency: 1))
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: "F47455", transparency: 1))
                                    }
                                }
                                .frame(
                                    width: 120, height: screenHeight * 0.045
                                )
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
                    .frame(width: self.screenWidth)
                    .ignoresSafeArea()
            )
        }
        .padding(EdgeInsets(top: 30, leading: 45, bottom: 40, trailing: 45))
        .frame(maxWidth: .infinity)
        .background(Color.clear)
        .onAppear {
            if let firstBoard = self.boardManager.boards.first {
                id = firstBoard.id
            }
        }
        .onChange(of: id) {
            self.boardManager.selectId(id)
        }
    }
}
