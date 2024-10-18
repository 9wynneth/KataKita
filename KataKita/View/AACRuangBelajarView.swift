//
//  AACRuangBelajarView.swift
//  KataKita
//
//  Created by Lisandra Nicoline on 18/10/24.
//

import SwiftUI
import AVFoundation


struct AACRuangBelajarView: View {
    @State private var showAACSettings = false
    @State private var pencilPressed = false
    @State private var showPlusButton = false
    @State private var showAlert = false
    @State private var hasSpoken = false
    @State private var selectedCategoryColor: String = "#FFFFFF"
    
    @StateObject private var boardModel = AACBoardModel()
    @ObservedObject var viewModel = AACRuangBelajarViewModel()
    @State private var selectedColumnIndex: [Card] = []
    @State private var selectedButton: [Card] = []
    @State private var isHome: Bool = false
    @State private var isSetting: Bool = false
    @Environment(\.dismiss) var dismiss
    
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
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .frame(width: screenWidth * (15 / 1376), height: screenHeight * (15 / 1032))
                    TextHeadline(
                        text: "Sequence",
                        size: 25,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                    )
                }
                Spacer()
            }
            .padding(.top,screenHeight * (110 / 1032))
            .padding(.bottom,screenHeight * (20 / 1032))
            .padding(.leading,screenWidth * (28 / 1376))
            
            HStack {
                Button(action: {
                    speakAllText(from: selectedButton)
                }) {
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width:screenWidth * (1190 / 1376),height:screenHeight * (140 / 1032))
                            .cornerRadius(10)
                            .padding(.leading, screenWidth * (28 / 1376))
                        
                        // HStack for displaying the selected buttons
                        HStack {
                            ForEach(Array(selectedButton.enumerated()), id: \.offset) { index, card in
                                if index < 11 {
                                    // Display CustomButton for the first 11 items
                                    CustomButton(
                                        icon: selectedButton[index].icon, // Access the icon from the Card model
                                        text: selectedButton[index].name, // Access the name from the Card model
                                        width: Int(screenWidth * (100 / 1376)),
                                        height: Int(screenHeight * (100 / 1032)),
                                        font: Int(screenWidth * (16 / 1376)),
                                        iconWidth: Int(screenWidth * (50 / 1376)),
                                        iconHeight: Int(screenHeight * (50 / 1032)),
                                        bgColor: selectedButton[index].category.color, // Convert hex string to Color
                                        bgTransparency: 1.0,
                                        fontColor: selectedButton[index].category.fontColor, // Convert hex string to Color
                                        fontTransparency: 1.0,
                                        cornerRadius: 10,
                                        isSystemImage: false,
                                        action: {
                                            // Define the button action here if needed
                                        }
                                    )
                                } else {
                                    // Display plain Text for items beyond the 11th
                                    Text(selectedButton[index].name) // Access the 'name' from the Card model
                                        .font(.system(size: screenWidth * (16 / 1376)))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, screenWidth * (5 / 1376))
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(5)
                                }
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, screenWidth * (33 / 1376))
                        .padding()
                     
                        HStack {
                            CustomButton(
                                icon: "delete",
                                width: Int(screenWidth * (100/1376.0)),
                                height: Int(screenHeight * (100/1032.0)),
                                font: Int(screenWidth * (40/1376.0)),
                                iconWidth: Int(screenWidth * (50/1376.0)),
                                iconHeight: Int(screenHeight * (50/1032.0)),
                                bgColor: "#000000",
                                bgTransparency: 0,
                                fontColor: "#ffffff",
                                fontTransparency: 1.0,
                                cornerRadius: 20,
                                isSystemImage: false,
                                action:{
                                    if !selectedButton.isEmpty {
                                        selectedButton.removeLast()
                                    }
                                }
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing,screenWidth * (4/1376.0))

                    }
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(1.0))
                        .frame(width: screenWidth * (110/1376.0),height: screenHeight * (110/1032.0))
                        .cornerRadius(20)
                        .shadow(radius: 5,x: 3,y:4)
                    
                    CustomButton(
                        icon: "trash",
                        width: Int(screenWidth * (100/1376.0)),
                        height: Int(screenHeight * (100/1032.0)),
                        font: Int(screenWidth * (40/1376.0)),
                        iconWidth: Int(screenWidth * (50/1376.0)),
                        iconHeight: Int(screenHeight * (50/1032.0)),
                        bgColor: "#000000",
                        bgTransparency: 0,
                        fontColor: "#ffffff",
                        fontTransparency: 1.0,
                        cornerRadius: 20,
                        isSystemImage: false,
                        action:{
                            if !selectedButton.isEmpty {
                                selectedButton.removeAll()
                            }
                        }
                    )
                    
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(.bottom,screenHeight * (50/1032.0))
            
            
            HStack {
                CustomButton(
                    icon: "WarnaKuning",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaUngu",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaPink",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaHijau",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaBiru",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaOrange",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaOrange",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
                CustomButton(
                    icon: "WarnaAbu",
                    width: Int(screenWidth * (100/1376.0)),
                    height: Int(screenHeight * (50/1032.0)),
                    font: Int(screenWidth * (40/1376.0)),
                    iconWidth: Int(screenWidth * (100/1376.0)),
                    iconHeight: Int(screenHeight * (50/1032.0)),
                    bgColor: "#000000",
                    bgTransparency: 0,
                    fontColor: "#ffffff",
                    fontTransparency: 1.0,
                    cornerRadius: 0,
                    isSystemImage: false,
                    action:{

                    }
                )
                .padding(.trailing,screenWidth * (28/1376.0))
                
            }
            .padding(.trailing,screenWidth * (218/1376.0))
            
            // ScrollView for buttons
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(1.0))
                    .frame(width: screenWidth * (1370/1376.0),height: screenHeight * (800/1032.0))
                    .cornerRadius(40)
                
                ScrollView {
                     LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth * (120/1376.0)))], spacing: screenWidth * (10/1376.0)) {
                         ForEach(0..<viewModel.cards.count, id: \.self) { columnIndex in
                             VStack(spacing: screenWidth * (10/1376.0)) {
                                 let rowLimit = (columnIndex == viewModel.cards.count - 1) ? 9 : 6
                                 
                                 ForEach(0..<rowLimit, id: \.self) { rowIndex in
                                     if rowIndex < viewModel.cards[columnIndex].count {
                                         let card = viewModel.cards[columnIndex][rowIndex]
                                         
                                         // Special design for the last column
                                         if columnIndex == viewModel.cards.count - 1 {
                                             CustomButton(
                                                text: card.name,
                                                width: Int(screenWidth * (100/1376.0)),
                                                height: Int(screenHeight * (60/1032.0)),
                                                font: Int(screenWidth * (18/1376.0)),
                                                iconWidth: Int(screenWidth * (50/1376.0)),
                                                iconHeight: Int(screenHeight * (50/1032.0)),
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
                                             .padding(.bottom, screenHeight * (3/1032.0))
                                         } else {
                                             // Default button for other columns
                                             CustomButton(
                                                icon: card.icon,
                                                text: card.name,
                                                width: Int(screenWidth * (100/1376.0)),
                                                height: Int(screenHeight * (100/1032.0)),
                                                font: Int(screenWidth * (16/1376.0)),
                                                iconWidth: Int(screenWidth * (65/1376.0)),
                                                iconHeight: Int(screenHeight * (65/1032.0)),
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
                                         }
                                     }
                                     else if viewModel.cards[columnIndex].count < 6 {
                                         let buttonsData = [
                                             0: ("#FFEBAF", "#000000"),
                                             1: ("#A77DFF", "#000000"),
                                             2: ("#FFB0C7", "#000000"),
                                             3: ("#CFF0C8", "#000000"),
                                             4: ("#CFF0C8", "#000000"),
                                             5: ("#D4F3FF", "#000000"),
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
                     .padding(.top, screenHeight * (40/1032.0))
                     .padding(.leading,screenWidth * (25/1376.0))
                 }
                 VStack{
                     ZStack {
                         Rectangle()
                             .fill(Color(hex: "#EEEEEE", transparency: 1))
                             .frame(width: screenWidth * (90/1376.0),height: screenHeight * (90/1032.0))
                             .cornerRadius(20)
                             .shadow(radius: 5,x: 3,y:4)
                         
                         CustomButton(
                             icon: "pencil",
                             width: Int(screenWidth * (50/1376.0)),
                             height: Int(screenHeight * (50/1032.0)),
                             font: Int(screenWidth * (40/1376.0)),
                             iconWidth: Int(screenWidth * (40/1376.0)),
                             iconHeight: Int(screenHeight * (40/1032.0)),
                             bgColor: "#000000",
                             bgTransparency: 0,
                             fontColor: "#696767",
                             fontTransparency: 1.0,
                             cornerRadius: 20,
                             isSystemImage: true,
                             action:{
 //                                showAACSettings = true
                                 handlePencilPress()
                             }
                         )
                         
                     }
                     .sheet(isPresented: $showAACSettings) {
                         AddButtonAACView(
                             viewModel: AACRuangMakanViewModel(),
                             navigateTooAddImage: CallAACSettingsView.$navigateTooAddImage,
                             selectedSymbolImage: CallAACSettingsView.$selectedSymbolImage,
                             navigateFromSymbols: CallAACSettingsView.$navigateFromSymbols,
                             navigateFromImage: CallAACSettingsView.$navigateFromImage,
                             selectedSymbolName: CallAACSettingsView.$selectedSymbolName,
                             selectedImage: .constant(nil),
                             categoryColor: $selectedCategoryColor, selectedColumnIndex: $selectedColumnIndex // Pass the selected category color
                         )
                     }


                    
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: "#EEEEEE", transparency: 1))
                            .frame(width: screenWidth * (90/1376.0),height: screenHeight * (90/1032.0))
                            .cornerRadius(20)
                            .shadow(radius: 5,x: 3,y:4)
                        
                        CustomButton(
                            icon: "home",
                            width: Int(screenWidth * (50/1376.0)),
                            height: Int(screenHeight * (50/1032.0)),
                            font: Int(screenWidth * (40/1376.0)),
                            iconWidth: Int(screenWidth * (40/1376.0)),
                            iconHeight: Int(screenHeight * (40/1032.0)),
                            bgColor: "#000000",
                            bgTransparency: 0,
                            fontColor: "#ffffff",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            isSystemImage: false,
                            action:{
                                isHome = true
                            }
                        )
                        
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(hex: "#EEEEEE", transparency: 1))
                            .frame(width: screenWidth * (90/1376.0),height: screenHeight * (90/1032.0))
                            .cornerRadius(20)
                            .shadow(radius: 5,x: 3,y:4)
                        
                        CustomButton(
                            icon: "settings",
                            width: Int(screenWidth * (50/1376.0)),
                            height: Int(screenHeight * (50/1032.0)),
                            font: Int(screenWidth * (40/1376.0)),
                            iconWidth: Int(screenWidth * (40/1376.0)),
                            iconHeight: Int(screenHeight * (40/1032.0)),
                            bgColor: "#000000",
                            bgTransparency: 0,
                            fontColor: "#ffffff",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            isSystemImage: false,
                            action:{
                                isSetting = true
                            }
                        )
                        
                    }
                }
                .padding(.leading,screenWidth * (1230/1376.0))
                .padding(.top,screenHeight * (270/1032.0))
                
            }
            
            .onAppear{
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
            }
            
        }
        .background(Color(hex: "#F7F5F0", transparency: 1))
        .navigationBarBackButtonHidden(true)
        NavigationLink (destination: SettingsView(), isActive: $isSetting
        ){
            
        }
        NavigationLink (destination: HomePageView(), isActive: $isHome
        ){
            
        }

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


}
