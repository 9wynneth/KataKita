//
//  Untitled.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 03/11/24.
//

import SwiftUI
import AVFoundation


struct BetterAACView: View {
    @Environment(SecurityManager.self) private var securityManager
       @Environment(BoardManager.self) private var boardManager
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
    @EnvironmentObject var viewModel: ProfileViewModel

    
    @State static var navigateFromImage = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    @State private var selectedColumnIndexValue: Int = -1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @State private var showAlert = false
    @State private var hasSpoken = false
    
    let colors: [Color] = [.black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow]
    let colorNames: [Color: String] = [
        .black: "Hitam",
        .brown: "Cokelat",
        .orange: "Oranye",
        .red: "Merah",
        .purple: "Ungu",
        .pink: "Pink",
        .blue: "Biru",
        .green: "Hijau",
        .yellow: "Kuning"
    ]
    
    @State private var id = UUID()
    
    @EnvironmentObject var sharedState: SharedState
    
    
    var selectedBoard: Board? {
        if let board = boardManager.boards.first(where: { $0.id == id }) {
            return board
            
        }
        
        return nil
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: Textfield && Delete
                HStack {
                    Button(action: {
                        speakAllText(from: sharedState.selectedCards)
                    }) {
                        ZStack {
                            HStack {
                                HStack (spacing: 20){
                                    ForEach(Array(sharedState.selectedCards.enumerated()), id: \.element.id) { index, card in
                                        if index < 10 {
                                            VStack {
                                                if card.isIconTypeImage
                                                {
                                                    Image(uiImage: (UIImage(named: card.icon) ?? UIImage()))
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                }
                                                else
                                                {
                                                    if viewModel.userProfile.gender {
                                                        if AllAssets.genderAssets.contains(card.name.lowercased()) {
                                                            Image(resolveIcon(for: "GIRL_" + card.icon))  // icon name is passed from the card
                                                                .resizable()
                                                                .frame(width: 50, height: 50)
                                                        }
                                                        else
                                                        {
                                                            Image(resolveIcon(for: card.icon))  // icon name is passed from the card
                                                                .resizable()
                                                                .frame(width: 50, height: 50)
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if AllAssets.genderAssets.contains(card.name.lowercased())
                                                        {
                                                            Image(resolveIcon(for: "BOY_" + card.icon))  // icon name is passed from the card
                                                                .resizable()
                                                                .frame(width: 50, height: 50)
                                                            
                                                        }
                                                        else
                                                        {
                                                            Image(resolveIcon(for: card.icon))  // icon name is passed from the card
                                                                .resizable()
                                                                .frame(width: 50, height: 50)
                                                            
                                                        }
                                                    }
                                                }
                                                Text(LocalizedStringKey(card.name))
                                                    .font(.system(size: 18))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    .foregroundColor(card.fontColor)
                                                    
                                            }
                                            .frame(width: 80, height: 80)
                                            .background(card.bgColor.opacity(card.bgTransparency)) // Apply the background color with transparency
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                                
                                .padding(.leading, 33)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                
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
                        if !sharedState.selectedCards.isEmpty {
                            sharedState.selectedCards.removeAll()
                            speechSynthesizer.stopSpeaking(at: .immediate)
                        }
                        
                    }
                }
                
                // MARK: Navigation && Actions
                HStack (spacing: 0) {
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
                                selectedColumnIndexValue = colIndex
                                showAACSettings = true
                                self.addingCard = colIndex
                            },
                            del: { colIndex, rowIndex in
                                print("remove \(colIndex) \(rowIndex)")
                                boardManager.removeCard(column: colIndex, row: rowIndex)
                            }
                        )
                    }
                    
                    VStack(spacing: screenHeight * 0.02) {
                        ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                            Button {
                                if sharedState.selectedCards.count < 10 {
                                    showAlert = false
                                    let colorName = colorNames[color] ?? "Unknown"
                                    
                                    let cardListItem = CardList(
                                        name: colorName,
                                        icon: "person.fill",
                                        bgColor: color,
                                        bgTransparency: 1.0,
                                        fontColor: color,
                                        isIconTypeImage: false
                                    )
                                    sharedState.selectedCards.append(cardListItem)
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
                                    .frame(width: 120, height: screenHeight * 0.045)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Kotak Kata Penuh"),
                                    message: Text("Kamu hanya bisa memilih 10 kata. Hapus kata yang sudah dipilih untuk memilih kata baru."),
                                    dismissButton: .default(Text("OK"), action: {
                                        hasSpoken = true
                                    })
                                )
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
                    if isAskPassword {
                        VStack {
                            SecurityView()
                        }
                        .frame(width: screenWidth, height: screenHeight + 50)
                        .background(Color.gray.opacity(0.3))
                        .onTapGesture{
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
                SettingsView(
                )
            }
           
        }
        .environmentObject(viewModel)
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

}

#Preview {
    BetterAACView()
}
