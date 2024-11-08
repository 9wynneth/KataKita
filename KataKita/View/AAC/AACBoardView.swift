//
//  AACBoardView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI
import AVFoundation

class SharedState: ObservableObject {
    @Published var selectedCards: [CardList] = []
}

struct AACBoardView : View {
    @Binding var editing: Bool
    @Binding var cards: [[Card]]?
    
    @State private var showAlert = false
    @State private var hasSpoken = false
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @EnvironmentObject var sharedState: SharedState
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var imageFromLocal: URL?
    let board: Board
    let spacing: CGFloat
    let add: ((Int) -> Void)?
    let del: ((Int, Int) -> Void)?
    
    var cellWidth: CGFloat {
        let size = CGFloat(board.gridSize.column)
        return (self.width - self.spacing * (size - 1)) / size
    }
    var cellHeight: CGFloat {
        let size = CGFloat(board.gridSize.row)
        return (self.height - self.spacing * (size - 1)) / size
    }
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    init(
        _ board: Board,
        spacing: CGFloat = 10,
        editing: Binding<Bool> = Binding.constant(false),
        cards: Binding<[[Card]]?> = Binding.constant(nil),
        add: ((Int) -> Void)? = nil,
        del: ((Int, Int) -> Void)? = nil
    ) {
        self.board = board
        self.spacing = spacing
        self._cards = cards
        self._editing = editing
        self.add = add
        self.del = del
    }
    
    //MARK: Viewport Size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        HStack(alignment: .top, spacing: self.spacing) {
            ForEach(Array(board.cards.enumerated()), id: \.offset) { colIndex, column in
                if self.editing && column.isEmpty {
                    CustomButton(
                        icon: "plus",
                        text: "",
                        width: cellWidth,
                        height: cellHeight,
                        font: 24,
                        iconWidth: 80,
                        iconHeight: 60,
                        bgColor: "efefef",
                        bgTransparency: 0.65,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 13,
                        isSystemImage: true
                    ) {
                        if let add = self.add {
                            add(colIndex)
                        }
                    }
                } else if !column.isEmpty {
                    VStack (spacing: self.spacing){
                        ForEach(Array(column.enumerated()), id: \.offset) { rowIndex, row in
                            ZStack(alignment: .topTrailing) {
                                if row.isIconTypeImage {
                                    CustomIcon(
                                        icon: row.icon,
                                        text: row.name,
                                        width: cellWidth,
                                        height: cellHeight,
                                        font: 24,
                                        iconWidth: 100,
                                        iconHeight: 100,
                                        bgColor: Color(hex: row.category.getColorString(), transparency: 1),
                                        bgTransparency: 0.65,
                                        fontColor: Color.black,
                                        fontTransparency: 1.0,
                                        cornerRadius: 13
                                    ){
                                        if sharedState.selectedCards.count < 10 {
                                            showAlert = false
                                            speakText(row.name)
                                            let cardListItem = CardList(name: row.name, icon: row.icon, bgColor: Color.white, bgTransparency: 0.0, fontColor: Color.black)
                                            sharedState.selectedCards.append(cardListItem)
                                        } else {
                                            showAlert = true
                                            hasSpoken = false
                                            if hasSpoken == false {
                                                speakText("Kotak Kata Penuh")
                                            }
                                        }
                                    }

                                    
                                } else if self.cards != nil {
                                    if viewModel.userProfile.gender {
                                        if AllAssets.genderAssets.contains(row.icon) {
                                            CustomButton(
                                                icon: resolveIcon(for: "GIRL_" + row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: self.getCardPos(row) == nil ? 0.3 : 1,
                                                fontColor: "000000",
                                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                                            ) {
                                                self.cardHandler(row)
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
                                        else
                                        {
                                            CustomButton(
                                                icon: resolveIcon(for: row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: self.getCardPos(row) == nil ? 0.3 : 1,
                                                fontColor: "000000",
                                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                                            ) {
                                                self.cardHandler(row)
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
                                    else
                                    {
                                        if AllAssets.genderAssets.contains(row.icon) {
                                            CustomButton(
                                                icon: resolveIcon(for: "BOY_" + row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: self.getCardPos(row) == nil ? 0.3 : 1,
                                                fontColor: "000000",
                                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                                            ) {
                                                self.cardHandler(row)
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
                                        else
                                        {
                                            CustomButton(
                                                icon: resolveIcon(for: row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: self.getCardPos(row) == nil ? 0.3 : 1,
                                                fontColor: "000000",
                                                fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                                            ) {
                                                self.cardHandler(row)
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
                                } else {
                                    if viewModel.userProfile.gender {
                                        if AllAssets.genderAssets.contains(row.icon) {
                                            CustomButton(
                                                icon: resolveIcon(for: "GIRL_" + row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: 0.65,
                                                fontColor: "000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 13,
                                                isSystemImage: false
                                            ) {
                                                if sharedState.selectedCards.count < 10 {
                                                    showAlert = false
                                                    speakText(row.name)
                                                    let cardListItem = CardList(name: row.name, icon: row.icon, bgColor: Color.white, bgTransparency: 0.0, fontColor: Color.black)
                                                    sharedState.selectedCards.append(cardListItem)
                                                } else {
                                                    showAlert = true
                                                    hasSpoken = false
                                                    if hasSpoken == false {
                                                        speakText("Kotak Kata Penuh")
                                                    }
                                                }
                                                
                                                
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
                                        else
                                        {
                                            CustomButton(
                                                icon: resolveIcon(for: row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: 0.65,
                                                fontColor: "000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 13,
                                                isSystemImage: false
                                            ) {
                                                if sharedState.selectedCards.count < 10 {
                                                    showAlert = false
                                                    speakText(row.name)
                                                    let cardListItem = CardList(name: row.name, icon: row.icon, bgColor: Color.white, bgTransparency: 0.0, fontColor: Color.black)
                                                    sharedState.selectedCards.append(cardListItem)
                                                } else {
                                                    showAlert = true
                                                    hasSpoken = false
                                                    if hasSpoken == false {
                                                        speakText("Kotak Kata Penuh")
                                                    }
                                                }
                                                
                                                
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
                                    else {
                                        if AllAssets.genderAssets.contains(row.icon) {
                                            CustomButton(
                                                icon: resolveIcon(for: "BOY_" + row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: 0.65,
                                                fontColor: "000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 13,
                                                isSystemImage: false
                                            ) {
                                                if sharedState.selectedCards.count < 10 {
                                                    showAlert = false
                                                    speakText(row.name)
                                                    let cardListItem = CardList(name: row.name, icon: row.icon, bgColor: Color.white, bgTransparency: 0.0, fontColor: Color.black)
                                                    sharedState.selectedCards.append(cardListItem)
                                                } else {
                                                    showAlert = true
                                                    hasSpoken = false
                                                    if hasSpoken == false {
                                                        speakText("Kotak Kata Penuh")
                                                    }
                                                }
                                                
                                                
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
                                        else
                                        {
                                            CustomButton(
                                                icon: resolveIcon(for: row.icon),
                                                text: row.name,
                                                width: cellWidth,
                                                height: cellHeight,
                                                font: 24,
                                                iconWidth: 80,
                                                iconHeight: 60,
                                                bgColor: row.category.getColorString(),
                                                bgTransparency: 0.65,
                                                fontColor: "000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 13,
                                                isSystemImage: false
                                            ) {
                                                if sharedState.selectedCards.count < 10 {
                                                    showAlert = false
                                                    speakText(row.name)
                                                    let cardListItem = CardList(name: row.name, icon: row.icon, bgColor: Color.white, bgTransparency: 0.0, fontColor: Color.black)
                                                    sharedState.selectedCards.append(cardListItem)
                                                } else {
                                                    showAlert = true
                                                    hasSpoken = false
                                                    if hasSpoken == false {
                                                        speakText("Kotak Kata Penuh")
                                                    }
                                                }
                                                
                                                
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
                                if self.editing {
                                    CustomButton(
                                        icon: "xmark",
                                        text: "",
                                        width: 25,
                                        height: 25,
                                        font: 24,
                                        iconWidth: 15,
                                        iconHeight: 15,
                                        bgColor: "F47455",
                                        bgTransparency: 1,
                                        fontColor: "ffffff",
                                        fontTransparency: 1.0,
                                        cornerRadius: 25,
                                        isSystemImage: true
                                    ) {
                                        if let del = self.del {
                                            del(colIndex, rowIndex)
                                        }
                                    }
                                    .offset(x: -5, y: 5)
                                }
                            }
                        }
                        if self.editing && column.count < self.board.gridSize.row {
                            CustomButton(
                                icon: "plus",
                                text: "",
                                width: cellWidth,
                                height: cellHeight,
                                font: 24,
                                iconWidth: 80,
                                iconHeight: 60,
                                bgColor: "efefef",
                                bgTransparency: 0.65,
                                fontColor: "000000",
                                fontTransparency: 1.0,
                                cornerRadius: 13,
                                isSystemImage: true
                            ) {
                                if let add = self.add {
                                    add(colIndex)
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            GeometryReader{ geometry in
                Color.clear
                    .onAppear {
                        self.height = geometry.frame(in: .global).height
                        self.width = geometry.frame(in: .global).width
                        
                        print(self.height, self.width)
                        print(self.screenHeight, self.screenWidth)
                    }
            }
        )
    }
    
    private func cardHandler(_ card: Card) {
        if var cards = self.cards, cards.count >= 2 {
            if let pos = self.getCardPos(card) {
                cards[pos.0].remove(at: pos.1)
            } else {
                if card.category == .CORE {
                    if cards[0].count < 5 {
                        cards[0].append(card)
                    }
                } else if let index = cards.firstIndex(where: { $0.contains(where: { $0.category == card.category }) }) {
                    if cards[index].count < 5 {
                        cards[index].append(card)
                    }
                } else if let index = cards[1...].firstIndex(where: { $0.isEmpty }) {
                    if cards[index].count < 5 {
                        cards[index].append(card)
                    }
                }
            }
            self.cards = cards
        }
    }
    
    private func getCardPos(_ card: Card) -> (Int, Int)? {
        guard let cards = self.cards else { return nil }
        
        for (colIndex, col) in cards.enumerated() {
            for (rowIndex, row) in col.enumerated() {
                if row.id == card.id {
                    return (colIndex, rowIndex)
                }
            }
        }
        
        return nil
    }

    func speakText(_ text: String) {
        // Menggunakan NSLocalizedString untuk mendapatkan string yang dilokalkan
        let localizedText = NSLocalizedString(text, comment: "")
        
        let utterance = AVSpeechUtterance(string: localizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    func speakAllText(from buttons: [CardList]) {
        // Menggabungkan semua nama dari model Card menjadi satu teks
        var fullText = ""
        for card in buttons {
            // Menggunakan NSLocalizedString untuk setiap nama kartu
            let localizedName = NSLocalizedString(card.name, comment: "")
            fullText += "\(localizedName) "
        }
        
        // Menggunakan AVSpeechSynthesizer untuk membaca teks lengkap
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID") // Bahasa Indonesia
        utterance.rate = 0.5 // Menetapkan kecepatan bicara
        speechSynthesizer.speak(utterance)
    }

    
}
