//
//  Untitled.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 03/11/24.
//

import AVFoundation
import SwiftUI
import Combine
import TipKit

class SharedMaxCards: ObservableObject {
    @Published var maxWidth: CGFloat
    @Published var cardWidth: CGFloat = 50
    @Published var spacing: CGFloat = 18
    
    init() {
        // Dynamically set maxWidth based on screen width
        maxWidth = UIScreen.main.bounds.width * 0.5
    }
    
    var maxCardsToShow: Int {
        Int((maxWidth + spacing) / (cardWidth + spacing))
    }
    
}

struct BetterAACView: View {
    var parentModeTip: ParentModeTip = ParentModeTip()
    
    @Environment(SecurityManager.self) private var securityManager
    @Environment(BoardManager.self) private var boardManager
    @Environment(AACViewModel.self) private var aacViewModel
    @Environment(ProfileViewModel.self) private var viewModel

    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager

    @State private var editingCard: (Int, Int) = (-1, -1)
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
    @State private var isAskPassword = false
    @State private var isPresented = true
    
    @State private var navigateFromImage = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    @State private var selectedColumnIndexValue: Int = -1

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @State private var showAlert = false
    @State private var hasSpoken = false

    @State private var id = UUID()
    
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
    var maxSelectedCard: Int {
        return Int(self.screenWidth * 0.5 / 65)
    }


    var body: some View {
        VStack(spacing: 0) {
            // MARK: Textfield && Delete
            HStack {
                Button(action: {
                    SpeechManager.shared.speakAllTextAAC(from: self.aacViewModel.cards)
                }) {
                    ZStack {
                        HStack {
                            HStack(spacing: 15) {
                                ForEach(Array(self.aacViewModel.cards), id: \.id) { card in
                                    AACCard(card)
                                }
                            }
                            .padding(.leading, 30)
                            .frame(
                                maxWidth: .infinity, maxHeight: .infinity,
                                alignment: .leading)

                            Spacer()

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
                                if !self.aacViewModel.cards.isEmpty {
                                    self.aacViewModel.cards.removeLast()
                                    speechSynthesizer.stopSpeaking(at: .immediate)
                                }
                            }
                        }
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
                    if !self.aacViewModel.cards.isEmpty {
                        self.aacViewModel.cards.removeAll()
                        speechSynthesizer.stopSpeaking(at: .immediate)
                    }

                }
            }

            // MARK: Navigation && Actions
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(boardManager.boards) { board in
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
                                    width: 35,
                                    height: 35,
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
                                    boardManager.removeBoard()
                                }
                            } else {
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
                        }
                        .padding(.horizontal, 15)
                        .frame(
                            width: id == board.id ? 165 : 80,
                            alignment: .trailing
                        )
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .background(
                            Rectangle()
                                .fill(
                                    Color(
                                        hex: id == board.id
                                            ? "FFFFFF" : "EFEFEF",
                                        transparency: 1)
                                )
                                .clipShape(
                                    .rect(
                                        topLeadingRadius: 10,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 10)
                                )
                        )
                        .animation(
                            .spring(duration: 0.25), value: id == board.id
                        )
                        .onTapGesture {
                            id = board.id
                            SpeechManager.shared.speakCardAAC(board.name)
                        }
                    }
                    if self.editing {
                        Button {
                            self.addingBoard = true
                            boardName = ""
                            selectedIcon = ""
                            showSheet = true
                        } label: {
                            ZStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(
                                        Color(
                                            hex: "000000", transparency: 1)
                                    )
                                    .frame(width: 30)
                            }
                            .padding(.horizontal, 15)
                            .frame(width: 80, height: 75)
                            .background(
                                Rectangle()
                                    .fill(
                                        Color(
                                            hex: "D4F3FF", transparency: 1)
                                    )
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 10,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 0,
                                            topTrailingRadius: 10)
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
                        action: {
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

                        if !self.editing {
                            isAskPassword = false
                        } else {
                            isAskPassword = true
                            parentModeTip.invalidate(reason: .actionPerformed)
                        }

                    }
                    .popoverTip(parentModeTip, arrowEdge: .top)
                    .tipViewStyle(HeadlineTipViewStyle())
                    
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
                            navigateFromImage = false
                            selectedColumnIndexValue = colIndex
                            stickerManager.clearStickerImage()
                            originalImageManager.clearImageFromLocal()
                            showAACSettings = true
                            self.addingCard = colIndex
                        },
                        del: { colIndex, rowIndex in
                            self.id = UUID()
                            self.id = board.id
                            self.boardManager.selectId(board.id)
                            self.boardManager.removeCard(column: colIndex, row: rowIndex)
                        },
                        edit: { colIndex, rowIndex in
                            self.editingCard = (colIndex, rowIndex)
                            print(self.editingCard)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.showAACSettings = true
                            }
                        }
                    )
                }

                VStack(spacing: screenHeight * 0.015) {
                    ForEach(Array(colorCards.enumerated()), id: \.offset) { index, color in
                        Button {
                            SpeechManager.shared.speakCardAAC(color.name)
                            if !self.aacViewModel.addCard(color) {
                                showAlert = true
                                hasSpoken = false
                                SpeechManager.shared.speakCardAAC("Kotak Kata Penuh")
                            }
                        } label: {
                            Group {
                                if case let .color(color) = color.type {
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
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Kotak Kata Penuh"),
                                message: Text(
                                    "Kamu hanya bisa memilih \(self.aacViewModel.cards.count) kata. Hapus kata yang sudah dipilih untuk memilih kata baru."
//                                    "Kamu hanya bisa memilih 10 kata. Hapus kata yang sudah dipilih untuk memilih kata baru."
                                ),
                                dismissButton: .default(
                                    Text("OK"),
                                    action: {
                                        hasSpoken = true
                                    }
                                )
                            )
                        }
                    }
                }
            }
            .padding(.top, 45)
            .frame(
                maxWidth: .infinity, maxHeight: .infinity,
                alignment: .topTrailing
            )
            .background(
                Rectangle()
                    .fill(Color.white)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 45, bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0, topTrailingRadius: 45)
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
        .overlay(
            Group {
                if isAskPassword {
                    VStack {
                        SecurityView()
                    }
                    .frame(width: screenWidth, height: screenHeight + 50)
                    .background(Color.gray.opacity(0.5))
                    .onTapGesture {
                        isAskPassword = false
                        self.editing.toggle()
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .onAppear {
            if let firstBoard = boardManager.boards.first {
                self.id = firstBoard.id
            }
        }
        .onChange(of: id) {
            self.boardManager.selectId(id)
            
            // Get the board name based on the id
            if let boardName = boardManager.selectedName(for: id) {
                SpeechManager.shared.speakCardAAC(boardName)
            }
        }
        .onChange(of: securityManager.isCorrect) {
            if securityManager.isCorrect {
                // Password is correct; toggle and reset values
                isAskPassword = false
                securityManager.isCorrect = false
            }

        }
        .sheet(isPresented: $showSheet) {
            BoardCreateView(
                boardName: $boardName,
                selectedIcon: $selectedIcon,
                gridSize: $gridSize,
                defaultButton: $defaultButton
            )
        }
        .sheet(isPresented: $showAACSettings) {
            CardCreateView(
                self.$navigateFromImage,
                self.$selectedColumnIndexValue,
                self.$showAACSettings,
                self.$editingCard
            )
            .onAppear {
                print("\(self.editingCard)")
            }
            .onDisappear {
                self.editingCard = (-1, -1)
            }
        }
        .sheet(isPresented: $showprofile) {
            SettingsView()
        }
        .onDisappear{
            SpeechManager.shared.stopSpeech()
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

struct AACCard: View {
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if case let .image(data) = self.card.type {
                Image(uiImage: UIImage(data: data) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else if case let .icon(icon) = self.card.type {
                Icon(icon, (50, 50))
            } else {
                Color.clear
                    .frame(width: 50, height: 50)
            }
            
            if ["Hitam", "Cokelat", "Oranye", "Merah", "Ungu", "Pink", "Biru", "Hijau", "Kuning", "Putih"].contains(card.name) {
                Text("")
            } else {
                Text(LocalizedStringKey(card.name))
                    .foregroundStyle(Color.black)
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            
        }
        .frame(width: 80, height: 80)
        .background(
            Color(hex: {
                if let type = card.type, case let .color(hex) = type {
                    return hex
                } else {
                    return "FFFFFF" // Default color if none is found
                }
            }(), transparency: 1)
        )
        .cornerRadius(8)
        
    }
}

#Preview {
    BetterAACView()
}

struct HeadlineTipViewStyle: TipViewStyle {
    func makeBody(configuration: TipViewStyle.Configuration) -> some View {
        VStack(alignment: .leading) {
            HStack {
                let localizedName = NSLocalizedString("MODE ORANG TUA", comment: "Concatenated text for speech synthesis")
                
                Text ("\(localizedName)").font(.system(.headline).smallCaps())
                Spacer()
                Button(action: { configuration.tip.invalidate(reason: .tipClosed) }) {
                    Image(systemName: "xmark").scaledToFit()
                }
            }
            
            Divider().frame(height: 1.0)
            
            HStack(alignment: .top) {
                configuration.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48.0, height: 48.0)
                
                VStack(alignment: .leading, spacing: 8.0) {
                    configuration.title?.font(.headline)
                    configuration.message?.font(.subheadline)
                    
                    ForEach(configuration.actions) { action in
                        Button(action: action.handler) {
                            action.label().foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
