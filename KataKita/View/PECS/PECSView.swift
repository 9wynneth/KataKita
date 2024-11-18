//
//  PECSView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import AVFoundation
import SwiftUI

enum DraggingState {
    case idle
    case reverting
    case reset
    case disappearing
}

struct PECSView: View {
    @Environment(PECSViewModel.self) var pecsViewModel
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
    @State private var draggingDropped: Card? = nil
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
    @State private var droppedCards: [Card?] = [
        nil, nil, nil, nil, nil, nil, nil,
    ]
    @State private var childCards: [[Card]] = [[], [], [], [], []]
    
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
                    PECSChildView(self.$childCards) { draggingChild in
                        self.draggingChild = draggingChild
                    }
                    .rotation3DEffect(
                        .degrees(toggleOn ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .animation(.easeInOut(duration: 0.6), value: toggleOn)
                    
                    PECSParentView()
                        .opacity(toggleOn ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(toggleOn ? 0 : -180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                    .animation(.easeInOut(duration: 0.6), value: toggleOn)                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "F7F5F0", transparency: 1.0))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThinMaterial)
                        .opacity(self.draggingDropped != nil ? 1 : 0)
                        .animation(.linear(duration: 0.15), value: self.draggingDropped != nil)
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
                                systemName: self.toggleOn
                                ? "figure.and.child.holdinghands"
                                : "figure.child.and.lock.open")
                        }
                        .shadow(
                            color: .black.opacity(0.14), radius: 4,
                            x: 0, y: 2
                        )
                        .offset(x: self.toggleOn ? 18 : -18)
                        .padding(24)
                        .animation(.spring(duration: 0.25), value: self.toggleOn)
                    }
                    .onTapGesture {
                        if !self.toggleOn {
                            isAskPassword = true
                        } else {
                            self.toggleOn.toggle()
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
                                message: Text(
                                    "Are you sure you want to reset all cards?"),
                                primaryButton: .destructive(Text("Reset")) {
                                    self.pecsViewModel.reset()
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
                                    .opacity(
                                        self.draggingChild != nil
                                        || self.draggingDropped != nil
                                        ? 1 : 0
                                    )
                                    .animation(
                                        .linear(duration: 0.15),
                                        value: self.draggingChild != nil
                                        || self.draggingDropped != nil)
                                
                                if let card {
                                    PECSCard(card) { draggingDropped in
                                        if let draggingDropped {
                                            self.draggingDropped =
                                            draggingDropped
                                            self.draggingDroppedIndex = i
                                        } else {
                                            self.draggingDropped = nil
                                            self.draggingDroppedIndex = nil
                                        }
                                    }
                                    .frame(height: 100)
                                    .onAppear {
                                        SpeechManager.shared.speakCardNamePECS(card)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            let frame = geometry.frame(
                                                in: .global)
                                            let bounds = (
                                                CGPoint(
                                                    x: frame.minX, y: frame.minY
                                                ),
                                                CGPoint(
                                                    x: frame.maxX, y: frame.maxY
                                                )
                                            )
                                            self.dropZones[i] = bounds
                                        }
                                }
                            )
                            .zIndex(self.draggingDroppedIndex == i ? 2 : 1)
                        }
                    }
                    .onTapGesture {
                        let validDroppedCards = droppedCards.compactMap { $0 }
                        SpeechManager.shared.speakAllTextPECS(for: validDroppedCards)
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
                    let validDroppedCards = droppedCards.compactMap { $0 }  // Remove any nil cards
                    SpeechManager.shared.speakAllTextPECS(for: validDroppedCards)
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
                    .onTapGesture {
                        isAskPassword = false
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
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
        .onChange(of: self.pecsViewModel.cards, initial: true) {
            self.childCards = self.pecsViewModel.cards
            
        }
        .sheet(isPresented: $isAddCard) {
            ZStack {
                Color.clear
                    .background(BackgroundClearView())
                    .edgesIgnoringSafeArea(.all)
                
                AddCardModalView()
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
                            x >= $0.0.x && x <= $0.1.x && y >= $0.0.y
                            && y <= $0.1.y
                        }) {
                            if self.droppedCards[index] == nil {
                                self.droppedCards[index] = card
                                self.removeCard(card)
                            }
                        }
                    }
                    if let card = self.draggingDropped,
                       let oldIndex = self.draggingDroppedIndex
                    {
                        let x = value.location.x
                        let y = value.location.y + self.dropOffset
                        if let index = self.dropZones.firstIndex(where: {
                            x >= $0.0.x && x <= $0.1.x && y >= $0.0.y
                            && y <= $0.1.y
                        }) {
                            if self.droppedCards[index] != nil {
                                self.droppedCards[oldIndex] =
                                self.droppedCards[index]
                            } else {
                                self.droppedCards[oldIndex] = nil
                            }
                            
                            self.droppedCards[index] = card
                            self.draggingDropped = nil
                            self.draggingDroppedIndex = nil
                        } else if y < self.screenHeight - 200 {
                            if let index = self.pecsViewModel.cards.firstIndex(where: {
                                $0.first?.category == card.category
                            }) {
                                self.childCards[index].append(card)
                            }
                            self.droppedCards[oldIndex] = nil
                        }
                    }
                }
        )
        .onDisappear {
            SpeechManager.shared.stopSpeech()
        }
    }
    
    private func removeCard(_ card: Card) {
        for (i, column) in self.childCards.enumerated() {
            if let index = column.firstIndex(where: { $0.id == card.id }) {
                self.childCards[i].remove(at: index)
                break
            }
        }
    }
    
    //TODO: RESET BASED ON COLUMNS BEFORE (ini masi template)
    private func restoreDeletedCards() {
        self.childCards = self.pecsViewModel.cards
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
    @State private var offsetCurr: CGPoint = .zero
    @State private var offsetLast: CGSize = .zero
    @State private var dragging = false
    
    let card: Card
    let f: (Card?) -> Void
    
    init(
        _ card: Card,
        f: @escaping (Card?) -> Void
    ) {
        self.card = card
        self.f = f
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                TextContent(
                    text: card.name,
                    size: 14,
                    color: "000000",
                    transparency: 0,
                    weight: "medium"
                )
            } else {
                TextContent(
                    text: card.name,
                    size: 14,
                    color: "000000",
                    transparency: 1,
                    weight: "medium"
                )
                .padding(.horizontal)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Group {
                if case let .color(color) = self.card.type {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: color, transparency: 1))
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: self.card.category.getColorString(), transparency: 1))
                }
            }
        )
        .offset(x: self.offsetCurr.x, y: self.offsetCurr.y)
        .gesture(self.makeDragGesture())
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
            .onEnded { _ in
                self.offsetCurr = .zero
                self.offsetLast = .zero
                self.dragging = false
                self.f(nil)
            }
    }
}
