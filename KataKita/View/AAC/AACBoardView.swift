import AVFoundation
//
//  AACBoardView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI

class SharedState: ObservableObject {
    @Published var selectedCards: [CardList] = []
}

struct AACBoardView: View {
    @Environment(ProfileViewModel.self) private var viewModel

    @Binding var editing: Bool
    @Binding var cards: [[Card]]?

    @State private var showAlert = false
    @State private var hasSpoken = false

    let speechSynthesizer = AVSpeechSynthesizer()

    @EnvironmentObject var sharedState: SharedState
    @EnvironmentObject var sharedCards: SharedMaxCards
    

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
                    AACBoardPlusButton((cellWidth, cellHeight)) {
                        if let add = self.add {
                            add(colIndex)
                        }
                    }
                } else if !column.isEmpty {
                    VStack(spacing: self.spacing) {
                        ForEach(Array(column.enumerated()), id: \.offset) { rowIndex, row in
                            ZStack(alignment: .topTrailing) {
                                AACBoardCard(
                                    row,
                                    (cellWidth, cellHeight),
                                    row.isIconTypeImage ? nil : resolveIcon(for: "\(self.genderHandler(row.icon))\(row.icon)")
                                ) {
                                    if self.cards != nil {
                                        self.cardHandler(row)
                                    } else {
                                        if sharedState.selectedCards.count < sharedCards.maxCardsToShow {
                                            showAlert = false
                                            speakText(row.name)
                                            let cardListItem = CardList(
                                                name: row.name,
                                                icon: row.icon,
                                                bgColor: Color.white,
                                                bgTransparency: 0.0,
                                                fontColor: Color.black,
                                                isIconTypeImage: row.isIconTypeImage
                                            )
                                            sharedState.selectedCards.append(cardListItem)
                                        } else {
                                            showAlert = true
                                            hasSpoken = false
                                            if hasSpoken == false {
                                                speakText("Kotak Kata Penuh")
                                            }
                                        }
                                    }
                                    
                                }
                            
                                
                                if self.editing {
                                    AACBoardDeleteButton() {
                                        if let del = self.del {
                                            del(colIndex, rowIndex)
                                        }
                                    }
                                    .offset(x: -5, y: 5)
                                }
                            }
                        }
                        if self.editing && column.count < self.board.gridSize.row {
                            AACBoardPlusButton((cellWidth, cellHeight)) {
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
        .frame(
            maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading
        )

        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.height = geometry.frame(in: .global).height
                        self.width = geometry.frame(in: .global).width

                        print(self.height, self.width)
                        print(self.screenHeight, self.screenWidth)
                    }
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(
                    "Kotak Kata Penuh"),
                message: Text(
                    "Kamu hanya bisa memilih \(sharedState.selectedCards.count) kata. Hapus kata yang sudah dipilih untuk memilih kata baru."
                ),
                dismissButton: .default(
                    Text("OK"),
                    action: {
                        hasSpoken = true
                    })
            )
        }
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
                } else if let index = cards.firstIndex(where: {
                    $0.contains(where: { $0.category == card.category })
                }) {
                    if cards[index].count < 5 {
                        cards[index].append(card)
                    }
                } else if let index = cards[1...].firstIndex(where: {
                    $0.isEmpty
                }) {
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
    
    private func genderHandler(_ name: String) -> String {
        if AllAssets.shared.genderAssets.contains(name) {
            if self.viewModel.userProfile.gender {
                return "GIRL_"
            }
            return "BOY_"
        }
        return ""
    }

    func speakText(_ text: String) {
        // Menggunakan NSLocalizedString untuk mendapatkan string yang dilokalkan
        let localizedText = NSLocalizedString(text, comment: "")
        // Memeriksa bahasa perangkat
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"

        let utterance = AVSpeechUtterance(string: localizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
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
        
        // Memeriksa bahasa perangkat
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"
        
        // Menggunakan AVSpeechSynthesizer untuk membaca teks lengkap
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
}

struct AACBoardPlusButton: View {
    let width: CGFloat
    let height: CGFloat

    let f: () -> Void


    init(_ size: (CGFloat, CGFloat), f: @escaping () -> Void) {
        self.width = size.0
        self.height = size.1
        self.f = f
    }

    var body: some View {
        CustomButton(
            icon: "plus",
            text: "",
            width: self.width,
            height: self.height,
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
            f()
        }
    }
}

struct AACBoardDeleteButton: View {
    let f: () -> Void

    init(f: @escaping () -> Void) {
        self.f = f
    }

    var body: some View {
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
            f()
        }
    }
}

struct AACBoardCard: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat
    let icon: String?
    let f: () -> Void
    
    init(_ card: Card, _ size: (CGFloat, CGFloat), _ icon: String?, f: @escaping () -> Void) {
        self.card = card
        self.width = size.0
        self.height = size.1
        self.icon = icon
        self.f = f
    }
    
    var body: some View {
        if self.card.isIconTypeImage {
            CustomIcon(
                icon: self.card.icon,
                text: self.card.name,
                width: self.width,
                height: self.height,
                font: 14,
                iconWidth: self.width / 2,
                iconHeight: self.width / 2,
                bgColor: Color(hex: self.card.category.getColorString(), transparency: 1),
                bgTransparency: 0.65,
                fontColor: Color.black,
                fontTransparency: 1.0,
                cornerRadius: 13
            ) {
                f()
            }
        } else if let icon = self.icon {
            CustomButton(
                icon: icon,
                text: self.card.name,
                width: self.width,
                height: self.height,
                font: 14,
                iconWidth: Int(self.width / 2),
                iconHeight: Int(self.width / 2),
                bgColor: self.card.category.getColorString(),
                bgTransparency: 0.65,
                fontColor: "000000",
                fontTransparency: 1.0,
                cornerRadius: 13,
                isSystemImage: false
            ) {
                f()
            }
        } else {
            EmptyView()
        }
    }
}
