//
//  PECSAddCardView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 04/11/24.
//

import SwiftUI

struct PECSAddCardView: View {
    //MARK: Viewport Size
    @State private var addingCard: Int? = nil
    @State private var addingBoard = false
    @State private var editing = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    @State private var id = UUID()
    @State private var searchText = ""

    var selectedBoard: Board? {
        if let board = BoardManager.shared.boards.first(where: { $0.id == id }) {
            return board
        }
        
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Navigation && Actions
            HStack (spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(BoardManager.shared.boards) { board in
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
                // MARK: Search Bar
                            HStack {
                                TextField("Search...", text: $searchText)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 5)
                            .padding(.bottom, 5)

            HStack(alignment: .top, spacing: 25) {
                if let board = self.selectedBoard {
                    AACBoardView(
                        board,
                        editing: self.$editing,
                        add: { colIndex in
                            self.addingCard = colIndex
                        },
                        del: { colIndex, rowIndex in
                            print("remove \(colIndex) \(rowIndex)")
                            BoardManager.shared.removeCard(column: colIndex, row: rowIndex)
                        }
                    )
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
            .padding(.top, 45)
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
        .padding(EdgeInsets(top: 30, leading: 45, bottom: 0, trailing: 45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hex: "BDD4CE", transparency: 1.0)
                .ignoresSafeArea()
        )
    
        .onChange(of: id) {
            BoardManager.shared.selectId(id)
        }
    }
    
}

#Preview {
    PECSAddCardView()
}
