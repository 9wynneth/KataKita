//
//  Untitled.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 03/11/24.
//

import AVFoundation
import SwiftUI
import Combine

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
    @Environment(SecurityManager.self) private var securityManager
    @Environment(BoardManager.self) private var boardManager
    @Environment(ProfileViewModel.self) private var viewModel

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
    @State var isAskPassword = false

    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager
    
    @State static var navigateFromImage = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    @State private var selectedColumnIndexValue: Int = -1

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var maxCards: Int {
        sharedState.selectedCards.count
    }

    @State private var showAlert = false
    @State private var hasSpoken = false

    @State private var id = UUID()
    
    let colors: [Color] = [
        Color(hex: "000000", transparency: 1.0),
        Color(hex: "835737", transparency: 1.0),
        Color(hex: "E9AE50", transparency: 1.0),
        Color(hex: "E54646", transparency: 1.0),
        Color(hex: "B378D8", transparency: 1.0),
        Color(hex: "EDB0DC", transparency: 1.0),
        Color(hex: "889AE4", transparency: 1.0),
        Color(hex: "B7D273", transparency: 1.0),
        Color(hex: "EFDB76", transparency: 1.0),
         Color(hex: "F2EFDE", transparency: 1.0)
    ]
    let colorNames: [Color: String] = [
        Color(hex: "000000", transparency: 1.0): "Hitam",
        Color(hex: "835737", transparency: 1.0): "Cokelat",
        Color(hex: "E9AE50", transparency: 1.0): "Oranye",
        Color(hex: "E54646", transparency: 1.0): "Merah",
        Color(hex: "B378D8", transparency: 1.0): "Ungu",
        Color(hex: "EDB0DC", transparency: 1.0): "Pink",
        Color(hex: "889AE4", transparency: 1.0): "Biru",
        Color(hex: "B7D273", transparency: 1.0): "Hijau",
        Color(hex: "EFDB76", transparency: 1.0): "Kuning",
         Color(hex: "F2EFDE", transparency: 1.0): "Putih"
    ]

    @EnvironmentObject var sharedState: SharedState
    @EnvironmentObject var sharedCards: SharedMaxCards
    

    var selectedBoard: Board? {
        if let board = boardManager.boards.first(where: { $0.id == id }) {
            return board
        }

        return nil
    }


    var body: some View {
        VStack(spacing: 0) {
            // MARK: Textfield && Delete
            HStack {
                Button(action: {
                    speakAllText(from: sharedState.selectedCards)
                }) {
                    ZStack {
                        HStack {
                            HStack(spacing: 20) {
                                  ForEach(Array(sharedState.selectedCards.prefix(sharedCards.maxCardsToShow)), id: \.id) { card in
                                        AACCard(
                                            card,
                                            card.isImageType ? nil : resolveIcon(for: "\(self.genderHandler(card.icon))\(card.icon)")
                                        )
                                }
                            }
                            .padding(.leading, 33)
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
                                if !sharedState.selectedCards.isEmpty {
                                    sharedState.selectedCards.removeLast()
                                    speechSynthesizer.stopSpeaking(
                                        at: .immediate)
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
                    if !sharedState.selectedCards.isEmpty {
                        sharedState.selectedCards.removeAll()
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
                            speakText(board.name)
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
                        }

                    }
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
                                BetterAACView.navigateFromImage = false
                                selectedColumnIndexValue = colIndex
                                stickerManager.clearStickerImage()
                                originalImageManager.clearImageFromLocal()
                                showAACSettings = true
                                self.addingCard = colIndex
                            },
                        del: { colIndex, rowIndex in
                            self.id = UUID()
                            self.id = board.id
                            print("remove \(colIndex) \(rowIndex)")
                            boardManager.removeCard(
                                column: colIndex, row: rowIndex)
                        }
                    )
                }

                VStack(spacing: screenHeight * 0.015) {
                    ForEach(Array(colors.enumerated()), id: \.offset) {
                        index, color in
                        Button {
                            if sharedState.selectedCards.count < sharedCards.maxCardsToShow {
                                showAlert = false
                                let colorName =
                                    colorNames[color] ?? "Unknown"

                                let cardListItem = CardList(
                                    name: colorName,
                                    icon: "person.fill",
                                    bgColor: color,
                                    bgTransparency: 1.0,
                                    fontColor: Color(hex: "000000", transparency: 1),
                                    isImageType: false
                                )
                                sharedState.selectedCards.append(
                                    cardListItem)
                                speakText(colorName)
                            } else {
                                showAlert = true
                                hasSpoken = false
                                if hasSpoken == false {
                                    speakText("Kotak Kata Penuh")
                                }
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color)
                                .frame(
                                    width: 120, height: screenHeight * 0.045
                                )
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Kotak Kata Penuh"),
                                message: Text(
                                    "Kamu hanya bisa memilih \(maxCards) kata. Hapus kata yang sudah dipilih untuk memilih kata baru."
                                ),
                                dismissButton: .default(
                                    Text("OK"),
                                    action: {
                                        hasSpoken = true
                                    })
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
                if isAskPassword {
                    VStack {
                        SecurityView()
                    }
                    .frame(width: screenWidth, height: screenHeight + 50)
                    .background(Color.gray.opacity(0.3))
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
                id = firstBoard.id
            }
        }
        .onChange(of: id) {
            boardManager.selectId(id)
            sharedState.selectedCards.removeAll()
            
            // Get the board name based on the id
            if let boardName = boardManager.selectedName(for: id) {
                speakText(boardName) // Speak the board's name
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
                navigateFromImage: BetterAACView.$navigateFromImage,
                selectedColumnIndexValue: $selectedColumnIndexValue,
                showAACSettings: $showAACSettings
            )
        }
        .sheet(isPresented: $showprofile) {
            SettingsView()
        }
    }

    func speakText(_ text: String) {
        let localizedText = NSLocalizedString(text, comment: "Text to be spoken")
        
        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"
        
        let utterance = AVSpeechUtterance(string: localizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    func speakAllText(from buttons: [CardList]) {
        // Concatenate all the localized names from the Card models into a single text
        var fullText = ""
        for card in buttons {

            let localizedName = NSLocalizedString(card.name, comment: "Concatenated text for speech synthesis")
            fullText += "\(localizedName) "
        }

        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"
        
        // Use the AVSpeechSynthesizer to speak the full text
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5 // Set the speech rate
        speechSynthesizer.speak(utterance)
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
    let card: CardList
    let icon: String?
    init(_ card: CardList, _ icon: String?) {
        self.card = card
        self.icon = icon
    }
    var body: some View {
        VStack(spacing: 0) {
            if self.card.isImageType {
                Image(
                    uiImage: (UIImage(
                        named: self.card.icon)
                        ?? UIImage())
                )
                .resizable()
                .frame(width: 50, height: 50)
            } else if let icon = self.icon {
                Image(icon)  // icon name is passed from the card
                    .resizable()
                    .frame(width: 50, height: 50)

            } else {
                EmptyView()
            }
            Text(
                LocalizedStringKey(self.card.name)
            )
            .foregroundColor(.black)
            .font(.system(size: 14))
            .lineLimit(1)
        }
        .frame(width: 80, height: 80)
        .background(
            self.card.bgColor.opacity(
                self.card.bgTransparency)
        )  // Apply the background color with transparency
        .cornerRadius(8)
    }
}

#Preview {
    BetterAACView()
}
