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
    
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    @State private var id = UUID()
    //    @State private var searchText = ""
    @Environment(BoardManager.self) private var boardManager
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
    
    //    var filteredCards: [[Card]] {
    //        guard let board = selectedBoard else { return [] }
    //        if searchText.isEmpty {
    //            return board.cards
    //        }
    //        return board.cards.map { column in
    //            column.filter { card in
    //                card.name.lowercased().contains(searchText.lowercased())
    //            }
    //        }
    //    }
    
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
                //                // MARK: Search Bar
                //                HStack {
                //                    HStack(spacing: 10) {
                //                        TextField("Search words", text: $searchText)
                //                            .padding(10)
                //                            .background(Color.white)
                //                            .cornerRadius(8)
                //                            .shadow(radius: 2)
                //
                //                        Spacer()
                //
                ////                        TextContent(text: "Selesai", size: 20, color: "000000", weight: "bold")
                ////                                                        .padding(.trailing, screenWidth * 0.04)
                //                    }
                //                    .frame(maxWidth: .infinity)
                //                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                //
                //                    Spacer()
                //
                //                }
                
                HStack(alignment: .top, spacing: 25) {
                    if let board = self.selectedBoard {
                        AACBoardView(board, cards: self.$pecsCards)
                    }
                    
                    VStack(spacing: screenHeight * 0.02) {
                        ForEach(Array(colors.enumerated()), id: \.offset) {index, color in
                            Button {} label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(color)
                                    .frame(width: 120, height: screenHeight * 0.05)
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
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
        .offset(y: 50)
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
            print(self.pecsCards)
            if let cards = self.pecsCards {
                self.cards = cards
            }
        }
        
    }
    
}


#Preview {
    AddCardModalView(Binding.constant([[Card]]()))
}
