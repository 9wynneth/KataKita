////
////  AACView.swift
////  KataKita
////
////  Created by Gwynneth Isviandhy on 30/10/24.
////
//
//
//import SwiftUI
//
//struct AACView: View {
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    let templateWidth = 1366.0
//    let templateHeight = 1024.0
//    
//    @State private var isExpanded1 = false
//    @State private var isExpanded2 = false
//    @State private var isExpanded3 = false
//    @State private var expandedButton: Int? = nil
//    @State private var isLesson  = false
//    @State private var isDone  = false
//
//
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing:-2) {
//                HStack(spacing:screenWidth * (30/templateWidth)) {
//                    Spacer()
//                    //textbox
//                    ZStack {
//                        HStack {
//                            
//                        }
//                        .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (120/templateHeight))
//                        .background(
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(Color(hex: "FFFFFF", transparency: 1.0))
//                        )
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            //delete button
//                            CustomButton(
//                                icon: "delete",
//                                width: Int(screenWidth * (90/templateWidth)),
//                                height: Int(screenHeight * (140/templateHeight)),
//                                font: 40,
//                                iconWidth: Int(screenWidth * (50/templateWidth)),
//                                iconHeight: Int(screenHeight * (50/templateHeight)),
//                                bgColor: "#ffffff",
//                                bgTransparency: 0.01,
//                                fontColor: "#ffffff",
//                                fontTransparency: 0,
//                                cornerRadius: 20,
//                                isSystemImage: false,
//                                action: {
//                                    //                            if !selectedButton.isEmpty {
//                                    //                                selectedButton.removeLast()
//                                    //                                speechSynthesizer.stopSpeaking(at: .immediate)
//                                    //                            }
//                                }
//                            )
//                        }
//                        .frame(width: screenWidth * (1100/templateWidth) , height: screenHeight * (150/templateHeight))
//                        
//                    }
//                    .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (110/templateHeight))
//                    
//                    //trash button
//                    CustomButton(
//                        icon: "trash",
//                        width: Int(screenWidth * (120/templateWidth)),
//                        height: Int(screenHeight * (120/templateHeight)),
//                        font: 40,
//                        iconWidth: Int(screenWidth * (40/templateWidth)),
//                        iconHeight: Int(screenHeight * (40/templateHeight)),
//                        bgColor: "FFFFFF",
//                        bgTransparency: 1.0,
//                        fontColor: "000000",
//                        fontTransparency: 1.0,
//                        cornerRadius: 20,
//                        isSystemImage: false,
//                        action:{
//                            //                            if !selectedButton.isEmpty {
//                            //                                selectedButton.removeAll()
//                            //                                speechSynthesizer.stopSpeaking(at: .immediate)
//                            //                            }
//                        }
//                    )
//                    Spacer()
//                }
//                .padding(.top,screenHeight * (80/templateHeight))
//                
//                HStack {
//                    Spacer()
//                    HStack(spacing: screenWidth * (10/templateWidth)) {
//                        CustomButton(
//                            icon: "settings",
//                            width: Int(screenWidth * (45/templateWidth)),
//                            height: Int(screenHeight * (45/templateHeight)),
//                            font: 20,
//                            iconWidth: Int(screenWidth * (30/templateWidth)),
//                            iconHeight: Int(screenHeight * (30/templateHeight)),
//                            bgColor: "FFFFFF",
//                            bgTransparency: 1.0,
//                            fontColor: "000000",
//                            fontTransparency: 1.0,
//                            cornerRadius: 50,
//                            isSystemImage: false
//                        )
//                        CustomButton(
//                            icon: "pencil",
//                            width: Int(screenWidth * (45/templateWidth)),
//                            height: Int(screenHeight * (45/templateHeight)),
//                            font: 20,
//                            iconWidth: Int(screenWidth * (30/templateWidth)),
//                            iconHeight: Int(screenHeight * (30/templateHeight)),
//                            bgColor: "FFFFFF",
//                            bgTransparency: 1.0,
//                            fontColor: "000000",
//                            fontTransparency: 1.0,
//                            cornerRadius: 50
//                        )
//                        CustomButton(
//                            icon: "lightbulb",
//                            width: Int(screenWidth * (45/templateWidth)),
//                            height: Int(screenHeight * (45/templateHeight)),
//                            font: 20,
//                            iconWidth: Int(screenWidth * (30/templateWidth)),
//                            iconHeight: Int(screenHeight * (30/templateHeight)),
//                            bgColor: "FFFFFF",
//                            bgTransparency: 1.0,
//                            fontColor: "000000",
//                            fontTransparency: 1.0,
//                            cornerRadius: 50,
//                            action: {
//                                isLesson.toggle()
//                            }
//                        )
//                    }
//                    .padding(.trailing, screenWidth * (50/templateWidth))
//                    .padding(.top, screenWidth * (5/templateWidth))
//                }
//                
//                Spacer()
//                
//                HStack(alignment: .top, spacing: 0) {
//                    Button(action: {
//                        withAnimation {
//                            expandedButton = (expandedButton == 1) ? nil : 1
//                        }
//                    }) {
//                        HStack {
//                            Image("makan") // replace with actual image name
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            
//                            if expandedButton == 1 {
//                                Text("RUANG MAKAN")
//                                    .font(.system(size: 14, weight: .bold))
//                                    .foregroundColor(.black)
//                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .shadow(radius: 2)
//                    }
//                    
//                    Button(action: {
//                        withAnimation {
//                            expandedButton = (expandedButton == 2) ? nil : 2
//                        }
//                    }) {
//                        HStack {
//                            Image("bak mandi") // replace with actual image name
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            
//                            if expandedButton == 2 {
//                                Text("KAMAR MANDI")
//                                    .font(.system(size: 14, weight: .bold))
//                                    .foregroundColor(.black)
//                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .shadow(radius: 2)
//                    }
//                    
//                    Button(action: {
//                        withAnimation {
//                            expandedButton = (expandedButton == 3) ? nil : 3
//                        }
//                    }) {
//                        HStack {
//                            Image("buku") // replace with actual image name
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            
//                            if expandedButton == 3 {
//                                Text("RUANG BELAJAR")
//                                    .font(.system(size: 14, weight: .bold))
//                                    .foregroundColor(.black)
//                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .shadow(radius: 2)
//                    }
//                    Button(action: {
//                        withAnimation {
//                            expandedButton = (expandedButton == 4) ? nil : 4
//                        }
//                    }) {
//                        HStack {
//                            Image("balok") // replace with actual image name
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                            
//                            if expandedButton == 4 {
//                                Text("RUANG BERMAIN")
//                                    .font(.system(size: 14, weight: .bold))
//                                    .foregroundColor(.black)
//                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(5)
//                        .shadow(radius: 2)
//                    }
//                    
//                    Spacer(minLength: 0)
//                    
//                }
//                .padding(.leading, screenWidth * (54/templateWidth))
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 30)
//                        .frame(width: screenWidth * (1370/templateWidth), height: screenHeight * (790/templateHeight))
//                        .padding(.bottom, screenWidth * (-20/templateWidth))
//                        .foregroundColor(Color(hex: "ffffff", transparency: 1.0))
//                    
//                    
//                    VStack(spacing: 20) {
//                        
//                        VStack {
//                            if isLesson {
//                                HStack {
//                                    Spacer()
//                                    NavigationLink(destination: PecsLessonView(), isActive: $isDone) {
//                                        TextContent(text: "Selesai", size: 20, color: "000000", weight: "bold")
//                                            .padding(.trailing, screenWidth * 0.04)
//                                            .onTapGesture {
//                                                isDone = true
//                                                print(isDone)
//                                            }
//                                    }
//                                    
//                                }
//                            }
//                            
//                            if expandedButton == 1 {
//                                CardsRuangMakanView(isLesson: $isLesson)
//                            }
//                            else if expandedButton == 2 {
//                                CardsKamarMandiView(isLesson: $isLesson)
//                            }
//                            else if expandedButton == 3 {
//                                CardsRuangBelajarView(isLesson: $isLesson)
//                            }
//                            else if expandedButton == 4 {
//                                CardsRuangBelajarView(isLesson: $isLesson)
//                            }
//                            
//                        }
//                        .padding(.top, screenWidth * (30/templateWidth))
//                        Spacer()
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 30)
//                        //                .frame(width: screenWidth * (1370/templateWidth), height: screenHeight * (720/templateHeight))
//                            .padding(.top, screenWidth * (30/templateWidth))
//                            .foregroundColor(Color(hex: "ffffff", transparency: 1.0))
//                    )
//                }
//                
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(hex: "BDD4CE", transparency: 1.0))
//            .ignoresSafeArea(.all)
//            .onAppear{
//                print(UIScreen.main.bounds.width)
//                print(UIScreen.main.bounds.height)
//            }
//        }
//    }
//}
//
//#Preview {
//    AACView()
//}


import SwiftUI
import AVFoundation

struct AACView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let templateWidth = 1366.0
    let templateHeight = 1024.0
    
    @State private var expandedButton: Int? = nil
    @State private var isLesson  = false
    @State private var defaultButton: Int = 4
    
    @State private var showSheet = false
    @State private var boardName = ""
    @State private var selectedIcon = ""
    @State private var gridSize = "4 x 5"
    @State private var selectedCard: [Card] = []

    let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(spacing:-2) {
            HStack(spacing:screenWidth * (30/templateWidth)) {
                Spacer()
                //textbox
                Button(action: {
                    speakAllText(from: selectedCard)
                }) {
                    ZStack {
                        HStack(alignment: .top) {
                            ForEach(selectedCard.indices, id: \.self) { index in
                                let card = selectedCard[index]
                                if index < 9 {
                                    // Display CustomButton for the first 8 items
                                    CustomButton(
                                        icon: resolveIcon(for: card.icon), // Access the icon from the Card model
                                        text: card.name, // Access the name from the Card model
                                        width: Int(screenWidth * (105 / 1376)),
                                        height: Int(screenHeight * (105 / 1032)),
                                        font: Int(screenWidth * (55 / 1376)),
                                        iconWidth: Int(screenWidth * (85 / 1376)),
                                        iconHeight: Int(screenHeight * (85 / 1032)),
                                        bgColor: "ffffff",
                                        bgTransparency: 0,
                                        fontColor: card.category.fontColor, // Convert hex string to Color
                                        fontTransparency: 1.0,
                                        cornerRadius: 10,
                                        isSystemImage: false,
                                        action: {
                                            // Define the button action here if needed
                                        }
                                    )
                                }
                            }
                        }
                        .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (120/templateHeight), alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hex: "FFFFFF", transparency: 1.0))
                        )
                        Spacer()
                        HStack {
                            Spacer()
                            //delete button
                            CustomButton(
                                icon: "delete",
                                width: Int(screenWidth * (90/templateWidth)),
                                height: Int(screenHeight * (140/templateHeight)),
                                font: 40,
                                iconWidth: Int(screenWidth * (50/templateWidth)),
                                iconHeight: Int(screenHeight * (50/templateHeight)),
                                bgColor: "#ffffff",
                                bgTransparency: 0.01,
                                fontColor: "#ffffff",
                                fontTransparency: 0,
                                cornerRadius: 20,
                                isSystemImage: false,
                                action: {
                                    if !selectedCard.isEmpty {
                                        selectedCard.removeLast()
                                        speechSynthesizer.stopSpeaking(at: .immediate)
                                    }
                                }
                            )
                        }
                        .frame(width: screenWidth * (1100/templateWidth) , height: screenHeight * (150/templateHeight))
                        
                    }
                }
                .frame(width: screenWidth * (1100/templateWidth), height: screenHeight * (110/templateHeight))
                
                //trash button
                CustomButton(
                    icon: "trash",
                    width: Int(screenWidth * (120/templateWidth)),
                    height: Int(screenHeight * (120/templateHeight)),
                    font: 40,
                    iconWidth: Int(screenWidth * (40/templateWidth)),
                    iconHeight: Int(screenHeight * (40/templateHeight)),
                    bgColor: "FFFFFF",
                    bgTransparency: 1.0,
                    fontColor: "000000",
                    fontTransparency: 1.0,
                    cornerRadius: 20,
                    isSystemImage: false,
                    action:{
                        if !selectedCard.isEmpty {
                            selectedCard.removeAll()
                            speechSynthesizer.stopSpeaking(at: .immediate)
                        }
                    }
                )
                Spacer()
            }
            .padding(.top,screenHeight * (80/templateHeight))
            
            HStack {
                Spacer()
                HStack(spacing: screenWidth * (10/templateWidth)) {
                    CustomButton(
                        icon: "settings",
                        width: Int(screenWidth * (45/templateWidth)),
                        height: Int(screenHeight * (45/templateHeight)),
                        font: 20,
                        iconWidth: Int(screenWidth * (30/templateWidth)),
                        iconHeight: Int(screenHeight * (30/templateHeight)),
                        bgColor: "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50,
                        isSystemImage: false
                    )
                    CustomButton(
                        icon: "pencil",
                        width: Int(screenWidth * (45/templateWidth)),
                        height: Int(screenHeight * (45/templateHeight)),
                        font: 20,
                        iconWidth: Int(screenWidth * (30/templateWidth)),
                        iconHeight: Int(screenHeight * (30/templateHeight)),
                        bgColor: "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50
                    )
                    CustomButton(
                        icon: "lightbulb",
                        width: Int(screenWidth * (45/templateWidth)),
                        height: Int(screenHeight * (45/templateHeight)),
                        font: 20,
                        iconWidth: Int(screenWidth * (30/templateWidth)),
                        iconHeight: Int(screenHeight * (30/templateHeight)),
                        bgColor: "FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 50,
                        action: {
                            isLesson.toggle()
                        }
                    )
                }
                .padding(.trailing, screenWidth * (50/templateWidth))
                .padding(.top, screenWidth * (5/templateWidth))
            }
            
            Spacer()
            
            HStack(alignment: .top, spacing: 0) {
                Button(action: {
                    withAnimation {
                        expandedButton = (expandedButton == 1) ? nil : 1
                        selectedCard = []
                    }
                }) {
                    HStack {
                        Image("makan") // replace with actual image name
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        if expandedButton == 1 {
                            Text("RUANG MAKAN")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                
                Button(action: {
                    withAnimation {
                        expandedButton = (expandedButton == 2) ? nil : 2
                        selectedCard = []
                    }
                }) {
                    HStack {
                        Image("bak mandi") // replace with actual image name
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        if expandedButton == 2 {
                            Text("KAMAR MANDI")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                
                Button(action: {
                    withAnimation {
                        expandedButton = (expandedButton == 3) ? nil : 3
                        selectedCard = []
                    }
                }) {
                    HStack {
                        Image("buku") // replace with actual image name
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        if expandedButton == 3 {
                            Text("RUANG BELAJAR")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                Button(action: {
                    withAnimation {
                        expandedButton = (expandedButton == 4) ? nil : 4
                        selectedCard = []
                    }
                }) {
                    HStack {
                        Image("balok") // replace with actual image name
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        if expandedButton == 4 {
                            Text("RUANG BERMAIN")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                
                if defaultButton >= 5 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 5) ? nil : 5
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 5 {
                                Text("RUANG TAMU")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                if defaultButton >= 6 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 6) ? nil : 6
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 6 {
                                Text("RUANG APAPUN")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                if defaultButton >= 7 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 7) ? nil : 7
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 7 {
                                Text("OUTDOOR")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                if defaultButton >= 8 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 8) ? nil : 8
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 8 {
                                Text("JALAN-JALAN KE SINGAPURA")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                if defaultButton >= 9 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 9) ? nil : 9
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 9 {
                                Text("JALAN-JALAN KE BRUNEI DARUSALAM")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                if defaultButton >= 10 {
                    Button(action: {
                        withAnimation {
                            expandedButton = (expandedButton == 10) ? nil : 10
                            selectedCard = []
                        }
                    }) {
                        HStack {
                            Image("makan") // replace with actual image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            if expandedButton == 10 {
                                Text("JALAN-JALAN KE AMERIKA SERIKAT")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                    }
                }
                
                Button(action: {
                    withAnimation {
                        expandedButton = (expandedButton == 11) ? nil : 11
                        selectedCard = []
                        showSheet = true // tampilkan sheet saat tombol + ditekan
                    }
                }) {
                    HStack {
                        Text("+")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.black)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .frame(width: 50, height: 50)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                }
                .sheet(isPresented: $showSheet) {
                    BoardCreateView(
                        boardName: $boardName,
                        selectedIcon: $selectedIcon,
                        gridSize: $gridSize,
                        defaultButton: $defaultButton // binding defaultButton di sini
                    )
                }
                
                Spacer(minLength: 0)
                
            }
            .padding(.leading, screenWidth * (54/templateWidth))
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: screenWidth * (1370/templateWidth), height: screenHeight * (790/templateHeight))
                    .padding(.bottom, screenWidth * (-20/templateWidth))
                    .foregroundColor(Color(hex: "ffffff", transparency: 1.0))
                
                
                VStack(spacing: 20) {
                    
                    VStack {
                        if isLesson {
                            HStack {
                                Spacer()
                                TextContent(text: "Done", size: 20, color: "000000", weight: "bold")
                                    .padding(.trailing, screenWidth * 0.04)
                                
                            }
                        }
                        
                        if expandedButton == 1 {
                            CardsCustom4x5View(isLesson: $isLesson, selectedCard: $selectedCard)
                        }
                        else if expandedButton == 2 {
                            CardsCustom4x7View(isLesson: $isLesson, selectedCard: $selectedCard)
                        }
                        else if expandedButton == 3 {
                            CardsCustom5x8View(isLesson: $isLesson, selectedCard: $selectedCard)
                        }
                        else if expandedButton == 4 {
                            CardsRuangBelajarView(isLesson: $isLesson, selectedCard: $selectedCard)
                        }
                        
                    }
                    .padding(.top, screenWidth * (30/templateWidth))
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                    //                .frame(width: screenWidth * (1370/templateWidth), height: screenHeight * (720/templateHeight))
                        .padding(.top, screenWidth * (30/templateWidth))
                        .foregroundColor(Color(hex: "ffffff", transparency: 1.0))
                )
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "BDD4CE", transparency: 1.0))
        .ignoresSafeArea(.all)
        .onAppear{
            print(UIScreen.main.bounds.width)
            print(UIScreen.main.bounds.height)
        }
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
}
