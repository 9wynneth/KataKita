//
//  Untitled.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 03/11/24.
//

import SwiftUI

struct BetterAACView: View {
    //MARK: Viewport Size
    @State private var addingCard: Int? = nil
    @State private var addingBoard = false
    @State private var editing = false
    
    @State private var showSheet = false
    @State private var boardName = ""
    @State private var selectedIcon = ""
    @State private var gridSize = "4 x 5"
    @State private var selectedCard: [Card] = []
    @State private var defaultButton: Int = 4
    @State private var showAACSettings = false
    @State private var showprofile = false
    
    @State static var navigateFromImage = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    @State private var selectedColumnIndexValue: Int = -1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    
    @State private var id = UUID()
    
    var selectedBoard: Board? {
        if let board = BoardManager.shared.boards.first(where: { $0.id == id }) {
            return board
        }
        
        return nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Textfield && Delete
            HStack (spacing: 20) {
                HStack {
                    HStack {
                        //TODO: create icon list
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    CustomButton(
                        icon: "delete",
                        width: 100,
                        height: 100,
                        font: 40,
                        iconWidth: 50,
                        iconHeight: 50,
                        bgColor: "#ffffff",
                        bgTransparency: 0.01,
                        fontColor: "#ffffff",
                        fontTransparency: 0,
                        cornerRadius: 20,
                        isSystemImage: false
                    ) {
                        //                            if !selectedButton.isEmpty {
                        //                                selectedButton.removeLast()
                        //                                speechSynthesizer.stopSpeaking(at: .immediate)
                        //                            }
                    }
                }
                .frame(height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "FFFFFF", transparency: 1.0))
                )
                CustomButton(
                    icon: "trash",
                    width: 100,
                    height: 100,
                    font: 40,
                    iconWidth: 50,
                    iconHeight: 50,
                    bgColor: "FFFFFF",
                    bgTransparency: 1.0,
                    fontColor: "000000",
                    fontTransparency: 1.0,
                    cornerRadius: 20,
                    isSystemImage: false
                ) {
                    //                            if !selectedButton.isEmpty {
                    //                                selectedButton.removeAll()
                    //                                speechSynthesizer.stopSpeaking(at: .immediate)
                    //                            }
                }
            }
            
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
                            if self.editing && id == board.id {
                                CustomButton(
                                    icon: "xmark",
                                    text: "",
                                    width: 50,
                                    height: 50,
                                    font: 24,
                                    iconWidth: 20,
                                    iconHeight: 20,
                                    bgColor: "F47455",
                                    bgTransparency: 1,
                                    fontColor: "FFFFFF",
                                    fontTransparency: 1.0,
                                    cornerRadius: 25,
                                    isSystemImage: true
                                ) {
                                    BoardManager.shared.removeBoard()
                                }
                            } else {
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
                    if self.editing {
                        Button {
                            self.addingBoard = true
                            showSheet = true
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color(hex: "000000", transparency: 1))
                                    .frame(width: 30)
                            }
                            .padding(.horizontal, 15)
                            .frame(width: 80, height: 75)
                            .background(
                                Rectangle()
                                    .fill(Color(hex: "D4F3FF", transparency: 1))
                                    .clipShape(
                                        .rect(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10)
                                    )
                            )
                        }
                    }
                }
                .frame(height: 75)
                Spacer()
                HStack(spacing: 10) {
                    CustomButton(
                        icon: "settings",
                        width: 45,
                        height: 45,
                        font: 20,
                        iconWidth: 20,
                        iconHeight: 20,
                        bgColor: "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50,
                        isSystemImage: false,
                        action:
                            {
                                showprofile = true
                            }
                    )
                    CustomButton(
                        icon: "pencil",
                        width: 45,
                        height: 45,
                        font: 20,
                        iconWidth: 20,
                        iconHeight: 20,
                        bgColor: self.editing ? "F47455" : "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50
                    ) {
                        self.editing.toggle()
                    }
                    CustomButton(
                        icon: "lightbulb",
                        width: 45,
                        height: 45,
                        font: 20,
                        iconWidth: 20,
                        iconHeight: 20,
                        bgColor: "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50,
                        action: {
//                            isLesson.toggle()
                        }
                    )
                }
            }
            .padding(.top, 15)
            
            // MARK: BOARD
            HStack(alignment: .top, spacing: 25) {
                if let board = self.selectedBoard {
                    AACBoardView(
                        board,
                        editing: self.$editing,
                        add: { colIndex in
                            selectedColumnIndexValue = colIndex
                            showAACSettings = true
                            self.addingCard = colIndex
                        },
                        del: { colIndex, rowIndex in
                            print("remove \(colIndex) \(rowIndex)")
                            BoardManager.shared.removeCard(column: colIndex, row: rowIndex)
                        }
                    )
                }

                VStack(spacing: screenHeight * 0.01) {
                    ForEach(Array(colors.enumerated()), id: \.offset) {index, color in
                        Button {} label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color)
                                .frame(width: 120, height: screenHeight * 0.045)
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
        .padding(EdgeInsets(top: 0, leading: 45, bottom: 0, trailing: 45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(hex: "BDD4CE", transparency: 1.0)
                .ignoresSafeArea()
        )
        // MARK: Add board form
        .overlay(
            Group {
                if self.addingBoard {
                    
                } else {
                    EmptyView()
                }
            }
        )
        // MARK: Add card form
        .overlay(
            Group {
                if let colIndex = self.addingCard {
                    
                } else {
                    EmptyView()
                }
            }
        )
        .onAppear {
            if let firstBoard = BoardManager.shared.boards.first {
                id = firstBoard.id
            }
        }
        .onChange(of: id) {
            BoardManager.shared.selectId(id)
        }
        .sheet(isPresented: $showSheet) {
            BoardCreateView(
                boardName: $boardName,
                selectedIcon: $selectedIcon,
                gridSize: $gridSize,
                defaultButton: $defaultButton // binding defaultButton di sini
            )
        }
        .sheet(isPresented: $showAACSettings) {
            CardCreateView(
                navigateFromImage: BetterAACView.$navigateFromImage,
                selectedColumnIndexValue: $selectedColumnIndexValue,
                showAACSettings: $showAACSettings
            )
        }
        .sheet(isPresented: $showprofile) {
            SettingsView(
            )
        }
    }
    
}

#Preview {
    BetterAACView()
}
