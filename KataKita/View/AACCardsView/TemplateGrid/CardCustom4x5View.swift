//
//  CardsRuangBelajarView.swift
//  KataKita
//
//  Created by Lisandra Nicoline on 30/10/24.
//

import SwiftUI
import AVFoundation

struct CardsCustom4x5View: View {
    @State private var showAACSettings = false
    @State private var pencilPressed = false
    @State private var showPlusButton = false
    @State private var showAlert = false
    @State private var hasSpoken = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    @State private var selectedColumnIndex: [Card] = []
    
    @StateObject private var boardModel = AACBoardModel()
    @EnvironmentObject var viewModel: AACCustom4x5ViewModel
    
    @State private var selectedButton: [Card] = []
    @State private var isHome: Bool = false
    @State private var isSetting: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedColumnIndexValue: Int = -1
    @State private var selectedRowIndexValue: Int = -1
    

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing:-13) {
            ZStack {
                VStack {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth * (180/1376.0), maximum: screenWidth * (185/1376.0)), alignment: .top)]) {
                        ForEach(0..<viewModel.cards.count, id: \.self) { columnIndex in
                            VStack(/*spacing: screenWidth * (20/1376.0)*/) {
                                let rowLimit = (columnIndex == viewModel.cards.count - 1) ? 9 : 6
                                
                                ForEach(0..<rowLimit, id: \.self) { rowIndex in
                                    if rowIndex < viewModel.cards[columnIndex].count {
                                        let card = viewModel.cards[columnIndex][rowIndex]
                                        
                                        // Special design for the last column
                                        if columnIndex == viewModel.cards.count - 1 {
                                            CustomButton(
                                               text: card.name,
                                               width: Int(screenWidth * (130/1376.0)),
                                               height: Int(screenHeight * (60/1032.0)),
                                               font: Int(screenWidth * (18/1376.0)),
                                               iconWidth: Int(screenWidth * (30/1376.0)),
                                               iconHeight: Int(screenHeight * (30/1032.0)),
                                               bgColor: card.category.color,
                                               bgTransparency: 1.0,
                                               fontColor: card.category.fontColor,
                                               fontTransparency: 1.0,
                                               cornerRadius: 15,
                                               isSystemImage: true,
                                               action: {
                                                   if selectedButton.count < 10 {
                                                       showAlert = false
                                                       speakText(card.name)
                                                       selectedButton.append(card)
                                                   } else {
                                                       showAlert = true
                                                       hasSpoken = false
                                                       if hasSpoken == false {
                                                           speakText("Kotak Kata Penuh")
                                                       }
                                                   }
                                               }
                                            )
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                   title: Text("Kotak Kata Penuh"),
                                                   message: Text("Kamu hanya bisa memilih 10 kata. Hapus kata yang sudah dipilih untuk memilih kata baru."),
                                                   dismissButton: .default(Text("OK"), action: {
                                                       hasSpoken = true
                                                   })
                                                )
                                            }
                                            .padding(.bottom, screenHeight * (6/1032.0))
                                        } else {
                                            // Default button for other columns
                                            CustomButton(
                                               icon: resolveIcon(for: card.icon),
                                               text: card.name,
                                               width: Int(screenWidth * (150/1376.0)),
                                               height: Int(screenHeight * (150/1032.0)),
                                               font: Int(screenWidth * (48/1376.0)),
                                               iconWidth: Int(screenWidth * (115/1376.0)),
                                               iconHeight: Int(screenHeight * (115/1032.0)),
                                               bgColor: card.category.color,
                                               bgTransparency: 1.0,
                                               fontColor: card.category.fontColor,
                                               fontTransparency: 1.0,
                                               cornerRadius: 10,
                                               isSystemImage: false,
                                               action: {
                                                   if selectedButton.count < 10 {
                                                       showAlert = false
                                                       speakText(card.name)
                                                       selectedButton.append(card)
                                                   } else {
                                                       showAlert = true
                                                       hasSpoken = false
                                                       if hasSpoken == false {
                                                           speakText("Kotak Kata Penuh")
                                                       }
                                                   }
                                               }
                                            )
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("Kotak Kata Penuh"),
                                                    message: Text("Kamu hanya bisa memilih 10 kata. Hapus kata yang sudah dipilih untuk memilih kata baru."),
                                                    dismissButton: .default(Text("OK"), action: {
                                                        hasSpoken = true
                                                    })
                                                )
                                            }
                                            .padding(.bottom, screenHeight * (13/1032.0))
                                        }
                                    }
                                    else if viewModel.cards[columnIndex].count < 6 {
                                        let buttonsData = [
                                            0: ("#FFEBAF", "#000000"),
                                            1: ("#A77DFF", "#000000"),
                                            2: ("#FFB0C7", "#000000"),
                                            3: ("#CFF0C8", "#000000"),
                                            4: ("#D4F3FF", "#000000"),
                                            5: ("#F2B95C", "#000000"),
                                            6: ("#F2B95C", "#000000"),
                                            7: ("#FFFFFF", "#000000")
                                        ]
                                        
                                        if let (bgColor, fontColor) = buttonsData[columnIndex] {
                                            // Show the CustomButton if showPlusButton is true
                                            CustomButton(
                                                text: "+",
                                                width: Int(screenWidth * (100/1376.0)),
                                                height: Int(screenHeight * (100/1032.0)),
                                                font: Int(screenWidth * (18/1376.0)),
                                                iconWidth: Int(screenWidth * (50/1376.0)),
                                                iconHeight: Int(screenHeight * (50/1032.0)),
                                                bgColor: bgColor,
                                                bgTransparency: 1.0,
                                                fontColor: fontColor,
                                                fontTransparency: 1.0,
                                                cornerRadius: 15,
                                                isSystemImage: false,
                                                action: {
                                                    selectedCategoryColor = bgColor
                                                    print(selectedCategoryColor)
                                                    showAACSettings = true
                                                }
                                            )
                                            .opacity(showPlusButton ? 1 : 0)
                                        }
                                    }


                                }
                            }
                        }
                    }
                    .padding(.top, screenHeight * (280/1032.0))
                    .padding(.leading,screenWidth * (53/1376.0))
                    .padding(.trailing,screenWidth * (53/1376.0))
                }
                .frame(width: 1350, height: screenHeight * 0.6)
                
            }
            
            .onAppear{
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
       
    }
    
    
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    func speakAllText(from buttons: [Card]) {
        // Concatenate all the names from the Card models into a single text
        var fullText = ""
        for card in buttons {
            fullText += "\(card.name) "
        }
        
        // Use the AVSpeechSynthesizer to speak the full text
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID") // Indonesian language
        utterance.rate = 0.5 // Set the speech rate
        speechSynthesizer.speak(utterance)
    }
    
    private func handlePencilPress() {
        // Check if any column has less than 6 items
        if viewModel.cards.contains(where: { $0.count < 6 }) {
            showPlusButton.toggle() // Show/hide plus button based on current state
        } else {
            showPlusButton = false // Hide the plus button if all columns are filled
        }
    }
    
    func resolveIcon(for iconName: String) -> String {
            if let _ = UIImage(named: iconName) {
                return iconName
            } else if let _ = UIImage(named: iconName.uppercased()) {
                return iconName.uppercased()
            } else if let _ = UIImage(named: iconName.lowercased()) {
                return iconName.lowercased()
            } else {
                // Fallback option if no icon is found
                return "defaultIcon" // You can define a default icon
            }
        }


}


