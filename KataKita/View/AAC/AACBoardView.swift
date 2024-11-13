//
//  AACBoardView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//

import SwiftUI
import AVFoundation

struct AACBoardView: View {
    @Environment(AACViewModel.self) private var aacViewModel
    @Environment(PECSViewModel.self) private var pecsViewModel
    @Environment(ProfileViewModel.self) private var viewModel

    @Binding var editing: Bool

    @State private var showAlert = false
    @State private var hasSpoken = false
    @State private var imageFromLocal: URL?
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    private let board: Board
    private let pecs: Bool
    private let spacing: CGFloat
    private let add: ((Int) -> Void)?
    private let del: ((Int, Int) -> Void)?
    private let speechSynthesizer: AVSpeechSynthesizer

    var cellWidth: CGFloat {
        let size = CGFloat(board.gridSize.column)
        return (self.width - self.spacing * (size - 1)) / size
    }
    var cellHeight: CGFloat {
        let size = CGFloat(board.gridSize.row)
        return (self.height - self.spacing * (size - 1)) / size
    }

    init(
        _ board: Board,
        pecs: Bool = false,
        spacing: CGFloat = 10,
        editing: Binding<Bool> = Binding.constant(false),
        add: ((Int) -> Void)? = nil,
        del: ((Int, Int) -> Void)? = nil
    ) {
        self.board = board
        self.pecs = pecs
        self.spacing = spacing
        self._editing = editing
        self.add = add
        self.del = del
        self.speechSynthesizer = .init()
    }

    //MARK: Viewport Size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        HStack(alignment: .top, spacing: self.spacing) {
            ForEach(Array(self.board.cards.enumerated()), id: \.offset) { colIndex, column in
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
                                    (cellWidth, cellHeight)
                                ) {
                                    if self.pecs {
                                        self.pecsViewModel.cardHandler(row)
                                    } else {
                                        if !self.aacViewModel.addCard(row) {
                                            self.showAlert = true
                                            self.hasSpoken = false
                                            self.speakText("Kotak Kata Penuh")
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
        .onDisappear{
            stopSpeech()
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
        .alert(isPresented: self.$showAlert) {
            Alert(
                title: Text(
                    "Kotak Kata Penuh"),
                message: Text(
                    "Kamu hanya bisa memilih \(self.aacViewModel.cards.count) kata. Hapus kata yang sudah dipilih untuk memilih kata baru."
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

    private func speakText(_ text: String) {
        stopSpeech()
        // Menggunakan NSLocalizedString untuk mendapatkan string yang dilokalkan
        let localizedText = NSLocalizedString(text, comment: "")
        // Memeriksa bahasa perangkat
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        let voiceLanguage = lang == "id" ? "id-ID" : "en-AU"

        let utterance = AVSpeechUtterance(string: localizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    private func speakAllText(from buttons: [Card]) {
        stopSpeech()
        // Menggabungkan semua nama dari model Card menjadi satu teks
        var fullText = ""
        for card in buttons {
            // Menggunakan NSLocalizedString untuk setiap nama kartu
            let localizedName = NSLocalizedString(card.name, comment: "")
            fullText += "\(localizedName) "
        }
        
        // Memeriksa bahasa perangkat
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        let voiceLanguage = lang == "id" ? "id-ID" : "en-AU"
        
        // Menggunakan AVSpeechSynthesizer untuk membaca teks lengkap
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    private func stopSpeech() {
        if self.speechSynthesizer.isSpeaking {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
        }
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
    let f: () -> Void
    
    init(_ card: Card, _ size: (CGFloat, CGFloat), f: @escaping () -> Void) {
        self.card = card
        self.width = size.0
        self.height = size.1
        self.f = f
    }
    
    var body: some View {
        Button {
            f()
        } label: {
            VStack(spacing: 10) { // Reduced spacing between Image and Text
                if case let .image(data) = self.card.type {
                    Image(uiImage: (UIImage(data: data) ?? UIImage()))
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.width / 2, height: self.height / 2)
                        .cornerRadius(13)
                } else if case let .icon(icon) = self.card.type {
                    Icon(icon, (self.width / 2, self.height / 2))
                } else {
                    Color.clear
                        .frame(width: self.width, height: self.height / 2)
                }
                
                TextContent(
                    text: self.card.name,
                    size: 14,
                    color: "000000",
                    transparency: 1.0,
                    weight: "medium"
                )
            }
            .frame(width: self.width, height: self.height)
            .background(
                Group {
                    if case let .color(color) = self.card.type {
                        Color(hex: color, transparency: 1)
                    } else {
                        Color(hex: self.card.category.getColorString(), transparency: 1)
                    }
                }
                .opacity(0.65)
            )
            .cornerRadius(13)
        }
    }
}
