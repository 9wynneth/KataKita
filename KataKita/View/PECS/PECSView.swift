//
//  PECSView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI
import AVFoundation

enum DraggingState {
    case idle
    case reverting
    case reset
    case disappearing
}

struct PECSView: View {
    @Environment(PECSViewModel.self) var pECSViewModel
    @Environment(SecurityManager.self) var securityManager
    @Environment(ProfileViewModel.self) private var viewModel

    //MARK: Viewport size
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    //MARK: Button color
    private let colors: [Color] = [
        .black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow,
    ]
    
    private let speechSynthesizer = AVSpeechSynthesizer()

    @State private var draggingChild: Card? = nil
    @State private var draggingChildState = DraggingState.idle
    @State private var draggingDropped: Card? = nil
    @State private var draggingDroppedState = DraggingState.idle
    @State private var draggingDroppedIndex: Int? = nil
    @State private var dropOffset: CGFloat = 0
    @State private var dropZones: [(CGPoint, CGPoint)] = [
        (.zero, .zero),
        (.zero, .zero),
        (.zero, .zero),
        (.zero, .zero),
        (.zero, .zero),
        (.zero, .zero),
        (.zero, .zero),
    ]
    @State private var droppedCards: [Card?] = [nil, nil, nil, nil, nil, nil, nil] // Binding to hold dropped cards
    @State private var childCards: [[Card]] = [[], [], [], [], []]

    @State private var deletedCards: [Card] = [] // Binding to hold dropped cards

    @State private var cards: [[Card]] = [[], [], [], [], []]
    @State private var toggleOn = false

    @State private var isAskPassword = false
    @State private var showAlert = false
    @State private var isAddCard = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: PECS PARENT AND CHILD
            HStack(alignment: .top, spacing: 20) {
                //whiteboard
                ZStack {
                    PECSChildView(self.$childCards, self.$draggingChildState) { draggingChild in
                        self.draggingChild = draggingChild
                    }

                    PECSParentView(self.$cards)
                        .opacity(toggleOn ? 1 : 0)
                        .animation(.easeInOut(duration: 0.25), value: toggleOn)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "F7F5F0", transparency: 1.0))
                )

                //MARK: toggle and button
                VStack(spacing: 20) {
                    //MARK: toggle
                    ZStack {
                        Capsule()
                            .frame(width: 80, height: 44)
                            .foregroundColor(Color.gray)
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Image(
                                systemName: toggleOn
                                    ? "figure.and.child.holdinghands"
                                    : "figure.child.and.lock.open")
                        }
                        .shadow(
                            color: .black.opacity(0.14), radius: 4,
                            x: 0, y: 2
                        )
                        .offset(x: toggleOn ? 18 : -18)
                        .padding(24)
                        .animation(.spring(duration: 0.25), value: toggleOn)
                    }
                    .onTapGesture {
                        if !toggleOn {
                            isAskPassword = true
                        } else {
                            toggleOn.toggle()
                            droppedCards = [nil, nil, nil, nil, nil, nil, nil]
                            restoreDeletedCards()
                        }
                    }
                    .animation(.spring(duration: 0.25), value: toggleOn)

                    //TODO: nanti masukin asset refresh

                    if toggleOn {
                        CustomButton(
                            icon: "arrow.clockwise",
                            width: 85,
                            height: 85,
                            font: 40,
                            iconWidth: 40,
                            iconHeight: 40,
                            bgColor: "F7F5F0",
                            bgTransparency: 1.0,
                            fontColor: "696767",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            action: {
                                self.showAlert = true

                            }
                        )
                        .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Refresh Cards"),
                                        message: Text("Are you sure you want to reset all cards?"),
                                        primaryButton: .destructive(Text("Reset")) {
                                            self.cards = [[], [], [], [], []]
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                        CustomButton(
                            icon: "plus.rectangle.fill.on.rectangle.fill",
                            width: 85,
                            height: 85,
                            font: 40,
                            iconWidth: 40,
                            iconHeight: 40,
                            bgColor: "ffffff",
                            bgTransparency: 1.0,
                            fontColor: "696767",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            action: {
                                isAddCard = true
                            }

                        )
                    }
                }
                .frame(width: 80)
            }
            .zIndex(2)

            // MARK: TEXT FIELD
            HStack(spacing: 20) {
                ZStack(alignment: .topLeading) {
                    HStack(spacing: 10) {
                        ForEach(Array(droppedCards.enumerated()), id: \.offset) { i, card in
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(hex: "f0f0f0", transparency: 1))
                                    .frame(height: 100)
                                    .opacity(self.draggingChild != nil || self.draggingDropped != nil ? 1 : 0)
                                    .animation(.linear(duration: 0.15), value: self.draggingChild != nil || self.draggingDropped != nil)
                                
                                if let card {
                                    PECSCard(
                                        self.$draggingDroppedState,
                                        card,
                                        card.isImageType ? nil : resolveIcon(for: "\(self.genderHandler(card.icon))\(card.icon)")
                                    ) { draggingDropped in
                                        if let draggingDropped {
                                            self.draggingDropped = draggingDropped
                                            self.draggingDroppedIndex = i
                                        } else {
                                            self.draggingDropped = nil
                                            self.draggingDroppedIndex = nil
                                        }
                                    }
                                    .frame(height: 100)
                                    .onAppear{
                                        speakCardName(card)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            let frame = geometry.frame(in: .global)
                                            let bounds = (CGPoint(x: frame.minX, y: frame.minY), CGPoint(x: frame.maxX, y: frame.maxY))
                                            self.dropZones[i] = bounds
                                        }
                                }
                            )
                            .zIndex(self.draggingDroppedIndex == i ? 2 : 1)
                        }
                    }
                    .onTapGesture {
                        // Pass all the dropped cards directly to the speakText function
                        let validDroppedCards = droppedCards.compactMap { $0 } // Remove any nil cards
                        speakText(for: validDroppedCards)
                    }
                    Color.clear
                        .frame(height: 100)
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "ffffff", transparency: 1.0))
                )
                .onTapGesture {
                    // Pass all the dropped cards directly to the speakText function
                    let validDroppedCards = droppedCards.compactMap { $0 } // Remove any nil cards
                    speakText(for: validDroppedCards)
                }
               
                CustomButton(
                    icon: "trash",
                    width: 80,
                    height: 80,
                    font: 50,
                    iconWidth: 50,
                    iconHeight: 50,
                    bgColor: "ffffff",
                    bgTransparency: toggleOn ? 0.0 : 1.0,
                    fontColor: "#696767",
                    fontTransparency: toggleOn ? 0.0 : 1.0,
                    cornerRadius: 20,
                    action: {
                        restoreDeletedCards()
                        droppedCards = [nil, nil, nil, nil, nil, nil, nil]
                    }
                )
            }
            .opacity(self.toggleOn ? 0 : 1)
            .zIndex(self.draggingDropped != nil ? 3 : 1)
        }
        .navigationBarBackButtonHidden(true)
        .padding(EdgeInsets(top: 0, leading: 45, bottom: 30, trailing: 45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            GeometryReader { geometry in
                Color(hex: "BDD4CE", transparency: 1)
                    .onAppear {
                        self.dropOffset = geometry.frame(in: .global).minY
                    }
            }
        )
        .overlay(
            Group {
                if isAskPassword {
                    VStack {
                        SecurityView()
                    }
                    .frame(width: screenWidth, height: screenHeight + 50)
                    .background(Color.gray.opacity(0.3))
                    .onTapGesture{
                        isAskPassword = false
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(self.dropZones)
            }
            
            let defaults = UserDefaults.standard
            
            if let raw = defaults.object(forKey: "pecs") as? Data {
                guard let cards = try? JSONDecoder().decode([[Card]].self, from: raw) else {
                    return
                }
                self.cards = cards
            }
            
            self.pECSViewModel.cards = self.cards
            self.childCards = self.cards
        }
        .onTapGesture {
            isAskPassword = false
        }
        .onTapGesture {
            isAskPassword = false
        }
        .onChange(of: securityManager.isCorrect) {
            if securityManager.isCorrect {
                // Password is correct; toggle and reset values
                toggleOn.toggle()
                droppedCards = [nil, nil, nil, nil, nil, nil, nil]
                restoreDeletedCards()
                isAskPassword = false
                securityManager.isCorrect = false
            }
        }
        .onChange(of: self.cards, initial: true) {
            self.pECSViewModel.cards = self.cards
        }
        .onChange(of: self.cards) {
            self.pECSViewModel.cards = self.cards
            self.childCards = self.cards

            guard let data = try? JSONEncoder().encode(self.cards) else {
                return
            }
            
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "pecs")
        }
        .sheet(isPresented: $isAddCard) {
            ZStack {
                Color.clear
                    .background(BackgroundClearView())
                    .edgesIgnoringSafeArea(.all)
                    
                AddCardModalView(self.$cards)
                    .frame(width: screenWidth)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .background(Color.clear)
                    .onTapGesture {
                        // Prevent sheet dismissal when tapping on the modal itself
                    }
            }
            .onTapGesture {
                isAddCard = false
            }
            .offset(y: 80)
        }
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if let card = self.draggingChild {
                        let x = value.location.x
                        let y = value.location.y + self.dropOffset
                        if let index = self.dropZones.firstIndex(where: {
                            x >= $0.0.x &&
                            x <= $0.1.x &&
                            y >= $0.0.y &&
                            y <= $0.1.y
                        }) {
                            if self.droppedCards[index] != nil {
                                self.draggingChildState = .reverting
                            } else {
                                self.draggingChildState = .disappearing
                                self.droppedCards[index] = card
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    self.removeCard(card)
                                }
                            }
                        } else {
                            self.draggingChildState = .reverting
                        }
                    }
                    if let card = self.draggingDropped, let oldIndex = self.draggingDroppedIndex {
                        let x = value.location.x
                        let y = value.location.y + self.dropOffset
                        if let index = self.dropZones.firstIndex(where: {
                            x >= $0.0.x &&
                            x <= $0.1.x &&
                            y >= $0.0.y &&
                            y <= $0.1.y
                        }) {
                            if self.droppedCards[index] != nil {
                                self.draggingDroppedState = .reset
                                self.droppedCards[oldIndex] = self.droppedCards[index]
                            } else {
                                self.droppedCards[oldIndex] = nil
                            }
                            
                            self.droppedCards[index] = card
                            self.draggingDropped = nil
                            self.draggingDroppedIndex = nil
                        } else if y < self.screenHeight - 200 {
                            self.draggingDroppedState = .disappearing
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                if let index = self.cards.firstIndex(where: { $0.first?.category == card.category }) {
                                    self.childCards[index].append(card)
                                }
                                self.droppedCards[oldIndex] = nil
                            }
                        } else {
                            self.draggingDroppedState = .reverting
                        }
                    }
                }
        )
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
    
    private func removeCard(_ card: Card) {
        for (i, column) in self.childCards.enumerated() {
            if let index = column.firstIndex(where: { $0.id == card.id }) {
                self.childCards[i].remove(at: index)
                deletedCards.append(card)  // Add the removed card to deletedCards
                break
            }
        }
    }

    //TODO: RESET BASED ON COLUMNS BEFORE (ini masi template)
    private func restoreDeletedCards() {
        self.childCards = self.cards
    }
    
    func speakCardName(_ card: Card) {
            // Localize the card name
            // Menggunakan NSLocalizedString untuk mendapatkan string yang dilokalkan
            let localizedText = NSLocalizedString(card.name, comment: "")
            // Memeriksa bahasa perangkat
            let languageCode = Locale.current.languageCode
            let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"

            let utterance = AVSpeechUtterance(string: localizedText)
            utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
            utterance.rate = 0.5
            speechSynthesizer.speak(utterance)
        }
        
        func speakText(_ text: String) {
           
        }

        func speakText(for cards: [Card]) {
            // Concatenate all the localized names from the Card models into a single text
            let fullText = cards.map { NSLocalizedString($0.name, comment: "Card name for speech synthesis") }.joined(separator: ", ")

            // Detect device language
            let languageCode = Locale.current.languageCode
            let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU" // Set the voice language based on device language
            
            // Create an utterance for the localized text
            let utterance = AVSpeechUtterance(string: fullText)
            utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage) // Set voice based on device language
            utterance.rate = 0.5 // Adjust the speech rate if needed

            // Use the AVSpeechSynthesizer to speak the full text
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct PECSCard: View {
    @Binding var state: DraggingState
    
    @State private var offsetCurr: CGPoint = .zero
    @State private var offsetLast: CGSize = .zero
    @State private var opacity = 1.0
    @State private var dragging = false
    
    let card: Card
    let icon: String?
    let f: (Card?) -> Void

    init(_ state: Binding<DraggingState>, _ card: Card, _ icon: String?, f: @escaping (Card?) -> Void) {
        self._state = state
        self.card = card
        self.icon = icon
        self.f = f
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if self.card.isImageType {
                Image(uiImage: (UIImage(named: self.card.icon) ?? UIImage()))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else if let icon = self.icon {
                Image(icon)
                    .antialiased(true)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                Color.clear
                    .frame(width: 50, height: 50)
            }
            
            TextContent(
                text: self.card.name,
                size: 14,
                color: "000000",
                transparency: 1,
                weight: "medium"
            )
            .padding(.horizontal)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: self.card.color ?? self.card.category.getColorString(), transparency: 1))
        )
        .offset(x: self.offsetCurr.x, y: self.offsetCurr.y)
        .opacity(self.opacity)
        .gesture(self.makeDragGesture())
        .onChange(of: self.state) {
            if self.dragging {
                if self.state == .disappearing {
                    withAnimation(.linear(duration: 0.15)) {
                        self.opacity = 0
                    } completion: {
                        self.offsetCurr = .zero
                        self.offsetLast = .zero
                        self.opacity = 1
                        self.state = .idle
                        self.dragging = false
                        self.f(nil)
                    }
                } else if self.state == .reverting {
                    withAnimation {
                        self.offsetCurr = .zero
                        self.offsetLast = .zero
                    } completion: {
                        self.state = .idle
                        self.dragging = false
                        self.f(nil)
                    }
                } else if self.state == .reset {
                    self.offsetCurr = .zero
                    self.offsetLast = .zero
                    self.state = .idle
                    self.dragging = false
                    self.f(nil)
                }
            }
        }
    }
    
    private func makeDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                if !self.dragging {
                    self.dragging = true
                    self.f(self.card)
                }
                let diff = CGPoint(
                    x: value.translation.width - self.offsetLast.width,
                    y: value.translation.height - self.offsetLast.height
                )
                self.offsetCurr = CGPoint(
                    x: self.offsetCurr.x + diff.x,
                    y: self.offsetCurr.y + diff.y
                )
                self.offsetLast = value.translation
            }
    }
}
