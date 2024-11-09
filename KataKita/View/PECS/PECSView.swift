//
//  PECSView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI
import AVFoundation

struct PECSView: View {
    @Environment(PECSViewModel.self) var pECSViewModel
    @Environment(SecurityManager.self) var securityManager
    @Environment(ProfileViewModel.self) private var viewModel

    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    //MARK: Button color
    let colors: [Color] = [
        .black, .brown, .orange, .red, .purple, .pink, .blue, .green, .yellow,
    ]

    let templateWidth = 1366.0
    let templateHeight = 1024.0

    @Binding var droppedCards: [Card]  // Binding to hold dropped cards
    @Binding var deletedCards: [Card]  // Binding to hold dropped cards
    private let speechSynthesizer = AVSpeechSynthesizer()

    @State private var childCards: [[Card]] = [[], [], [], [], []]
    @State private var cards: [[Card]] = [[], [], [], [], []]
    @State private var position = CGSize.zero
    @State private var scale: CGFloat = 1.0  // State to track scale for pinch gesture
    //    @State private var dragAmount: CGPoint?
    @State private var dragAmounts: [UUID: CGPoint] = [:]  // Dictionary for each card's drag amount
    @State var toggleOn = false

    @State var isAskPassword = false
    @State private var showAlert = false
    @State private var isAddCard = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            //part 2
            HStack(alignment: .top, spacing: 20) {
                //whiteboard
                ZStack {
                    PECSChildView(self.$childCards)
                        .opacity(toggleOn ? 0 : 1)
                        .rotation3DEffect(
                            .degrees(toggleOn ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(
                            .easeInOut(duration: 0.5), value: toggleOn)

                    PECSParentView(self.$cards)
                        .opacity(toggleOn ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(toggleOn ? 0 : -180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(
                            .easeInOut(duration: 0.5), value: toggleOn)
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

            //part 3
            HStack(spacing: 20) {
                HStack {
                    ForEach(droppedCards) { card in
                        PECSCard(
                            card,
                            card.isIconTypeImage ? nil : resolveIcon(for: "\(self.genderHandler(card.icon))\(card.icon)")
                        )
                    }

                    Color.clear
                        .frame(height: 100)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "ffffff", transparency: toggleOn ? 0.0 : 1.0))
                )
                .onDrop(of: [.cardType], isTargeted: nil) { items, _ in
                    guard let item = items.first else { return false }

                    let _ = item.loadTransferable(type: Card.self) { result in
                        if let loadedCard = try? result.get() {
                            droppedCards.append(loadedCard)
                            removeCard(loadedCard)
                            speakCardName(loadedCard)

                        } else {
                            print("Failed to load dropped card.")
                        }
                    }
                    return true
                }
                .onTapGesture{
                    speakText(for: droppedCards)
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
                        droppedCards.removeAll()
                    }
                )
            }
        }
        .padding(EdgeInsets(top: 0, leading: 45, bottom: 30, trailing: 45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "BDD4CE", transparency: 1))
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            isAskPassword = false
        }
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
        .onTapGesture {
            isAskPassword = false
        }
        .onChange(of: securityManager.isCorrect) {
            if securityManager.isCorrect {
                // Password is correct; toggle and reset values
                toggleOn.toggle()
                isAskPassword = false
                securityManager.isCorrect = false
            }
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
        .onAppear {
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
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isAddCard) {
            ZStack {
                Color.clear
                    .background(BackgroundClearView())
                    .edgesIgnoringSafeArea(.all)
                    
                AddCardModalView(self.$cards)
                    .offset(y: 20)
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
        }
        .onChange(of: self.cards, initial: true) {
            print(self.cards)
            self.pECSViewModel.cards = self.cards
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
    
    func removeCard(_ card: Card) {
        for (i, column) in self.childCards.enumerated() {
            if let index = column.firstIndex(where: { $0.id == card.id }) {
                self.childCards[i].remove(at: index)
                deletedCards.append(card)  // Add the removed card to deletedCards
                break
            }
        }
    }

    //TODO: RESET BASED ON COLUMNS BEFORE (ini masi template)
    func restoreDeletedCards() {
        self.childCards = self.cards
    }
    
    func speakCardName(_ card: Card) {
        // Localize the card name
        let localizedName = NSLocalizedString(card.name, comment: "Card name for speech synthesis")
        
        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU" // Set the voice language based on device language
        
        // Create an utterance with the localized card name
        let utterance = AVSpeechUtterance(string: localizedName)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage) // Set voice based on device language
        utterance.rate = 0.5 // Optional: set the speech rate

        // Use the AVSpeechSynthesizer to speak the localized card name
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
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
    let card: Card
    let icon: String?

    init(_ card: Card, _ icon: String?) {
        self.card = card
        self.icon = icon
    }
    
    var body: some View {
        if self.card.isIconTypeImage {
            CustomIcon(
                icon: self.card.icon,
                text: self.card.name,
                width: 100,
                height: 100,
                font: 14,
                iconWidth: 50,
                iconHeight: 50,
                bgColor: Color(hex: card.category.getColorString(), transparency: 1),
                bgTransparency: 0.65,
                fontColor: Color.black,
                fontTransparency: 1.0,
                cornerRadius: 13
            ) {}
        } else if let icon = self.icon {
            CustomButton(
                icon: icon,
                text: self.card.name,
                width: 100,
                height: 100,
                font: 14,
                iconWidth: 50,
                iconHeight: 50,
                bgColor: self.card.category.getColorString(),
                bgTransparency: 0.65,
                fontColor: "000000",
                fontTransparency: 1.0,
                cornerRadius: 13,
                isSystemImage: false
            )
        } else {
            EmptyView()
        }
    }
}
//extension PECSView: DropDelegate {
//    func performDrop(info: DropInfo) -> Bool {
//        guard let item = info.itemProviders(for: ["public.text"]).first else { return false }
//
//        item.loadObject(ofClass: String.self) { (string, error) in
//            if let text = string as? String {
//                print("Dropped text: \(text)") // Handle the dropped text
//                // Here you can update your model or UI as needed
//            }
//        }
//        return true
//    }
////}
//#Preview {
//    PECSView()
//        .environment(SecurityManager())
//        .environment(PECSViewModel())
//}
