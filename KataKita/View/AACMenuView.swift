////
////  AACMenuView.swift
////  KataKita
////
////  Created by Gwynneth Isviandhy on 18/10/24.
////
//
//import SwiftUI
//import AVFoundation
//
//struct AACMenuView: View {
//    
//    @Environment(StateManager.self) private var stateManager
//    @Environment(ScheduleManager.self) private var scheduleManager
//
//    private let speechSynthesizer = AVSpeechSynthesizer()
//    
//    //MARK: ViewportSize
//    let viewPortWidth = UIScreen.main.bounds.width
//    let viewPortHeight = UIScreen.main.bounds.height
//    
//    @Environment(\.dismiss) var dismiss
//    @State private var selectedRuangan: String = ""
//    @State private var shouldNavigate: Bool = false
//    
//    var selectedDay: Day {
//        let dayNumber = Date().dayNumberOfWeek()
//        switch dayNumber {
//        case 0:
//            return .SUNDAY([])
//        case 1:
//            return .MONDAY([])
//        case 2:
//            return .TUESDAY([])
//        case 3:
//            return .WEDNESDAY([])
//        case 4:
//            return .THURSDAY([])
//        case 5:
//            return .FRIDAY([])
//        default:
//            return .SATURDAY([])
//        }
//    }
//
//    var day: Day {
//        let currentSchedule = self.scheduleManager.schedules.first { $0.day == self.selectedDay }
//        return currentSchedule?.day ?? self.selectedDay
//    }
//
//    var extractActivity: [Activity] {
//        return self.day.extractActivities()
//    }
//
//    var ruangan: [Ruangan] {
//        return self.extractActivity.map { $0.ruangan }
//    }
//
//
//    var body: some View {
//        VStack {
//            VStack {
//                HStack {
//                    TextHeadline(text: "PAPAN AAC",
//                                 size: 50,
//                                 color: "000000",
//                                 weight: "bold")
//                    Spacer()
//                    
//                    NavigationLink(destination: HomePageView()){
//                        CustomButton(
//                            icon: "house.fill",
//                            width: 70,
//                            height: 70,
//                            font: 50,
//                            iconWidth: 30,
//                            iconHeight: 30,
//                            bgColor: "F7F5F0",
//                            bgTransparency: 1.0,
//                            fontColor: "696767",
//                            fontTransparency: 1.0,
//                            cornerRadius: 20,
//                            action: {
//                                dismiss()
//                            }
//                        )
//                    }
//                    
//                    NavigationLink(destination: SettingsView()){
//                        CustomButton(
//                            icon: "gearshape.fill",
//                            width: 70,
//                            height: 70,
//                            font: 50,
//                            iconWidth: 30,
//                            iconHeight: 30,
//                            bgColor: "F7F5F0",
//                            bgTransparency: 1.0,
//                            fontColor: "696767",
//                            fontTransparency: 1.0,
//                            cornerRadius: 20,
//                            action: {
//                                selectedRuangan = "Settings"
//                                shouldNavigate = true
//                            }
//                        )
//                    }
//                    
//                }
//                .padding()
//                .padding(.horizontal, 50)
//                .padding(.top,30)
//                
//                HStack {
//                    LazyVGrid(
//                        columns: [
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible())
//                        
//                        ],
//                        spacing: 30
//                    ) {
//                        NavigationLink(destination: AACRuangMakanView()){
//                            ActivityCard(
//                                icon: resolveIcon(for: "MAKAN"), // Assuming `ruangan` has an image
//                                nomor: "",
//                                text: "Ruang Makan",
//                                width: Int((viewPortWidth * 0.75 - 290) / 4),
//                                height: Int(viewPortWidth * (180 / 1210.0)),
//                                font: Int(viewPortWidth * (15 / 1210.0)),
//                                iconWidth: Int(viewPortWidth * (80 / 1210.0)),
//                                iconHeight: Int(viewPortHeight * (80 / 834.0)),
//                                bgColor: "F7F5F0",
//                                bgTransparency: 1.0,
//                                fontColor: "000000",
//                                fontTransparency: 1.0,
//                                cornerRadius: 20,
//                                isSystemImage: false,
//                                action: {
//                                    selectedRuangan = "RuangMakan"
//                                    shouldNavigate = true
//                                    speakText(selectedRuangan)
//
//                                }
//                            )
//                            
//                        }
//                        
//                        NavigationLink(destination: AACKamarMandiView()){
//                            ActivityCard(
//                                icon: resolveIcon(for: "TOILET"),
//                                nomor: "",
//                                text: "Kamar Mandi",
//                                width: Int((viewPortWidth * 0.75 - 290) / 4),
//                                height: Int(viewPortWidth * (180 / 1210.0)),
//                                font: Int(viewPortWidth * (15 / 1210.0)),
//                                iconWidth: Int(viewPortWidth * (95 / 1210.0)),
//                                iconHeight: Int(viewPortHeight * (95 / 834.0)),
//                                bgColor: "F7F5F0",
//                                bgTransparency: 1.0,
//                                fontColor: "000000",
//                                fontTransparency: 1.0,
//                                cornerRadius: 20,
//                                isSystemImage: false,
//                                action: {
//                                    selectedRuangan = "KamarMandi"
//                                    shouldNavigate = true
//                                    speakText(selectedRuangan)
//
//                                }
//                            )
//                           
//                        }
//                        NavigationLink(destination: AACRuangBelajarView()){
//                            ActivityCard(
//                                icon: resolveIcon(for: "BACA"),
//                                nomor: "",
//                                text: "Ruang Belajar",
//                                width: Int((viewPortWidth * 0.75 - 290) / 4),
//                                height: Int(viewPortWidth * (180 / 1210.0)),
//                                font: Int(viewPortWidth * (15 / 1210.0)),
//                                iconWidth: Int(viewPortWidth * (80 / 1210.0)),
//                                iconHeight: Int(viewPortHeight * (80 / 834.0)),
//                                bgColor: "F7F5F0",
//                                bgTransparency: 1.0,
//                                fontColor: "000000",
//                                fontTransparency: 1.0,
//                                cornerRadius: 20,
//                                isSystemImage: false,
//                                action: {
//                                    selectedRuangan = "RuangBelajar"
//                                    shouldNavigate = true
//                                    speakText(selectedRuangan)
//                                }
//                            )
//                            
//                        }
//                        
//                        NavigationLink(destination: AACRuangBermainView()){
//                            ActivityCard(
//                                icon: resolveIcon(for: "BERMAIN"),
//                                nomor: "",
//                                text: "Ruang Bermain",
//                                width: Int((viewPortWidth * 0.75 - 290) / 4),
//                                height: Int(viewPortWidth * (180 / 1210.0)),
//                                font: Int(viewPortWidth * (15 / 1210.0)),
//                                iconWidth: Int(viewPortWidth * (80 / 1210.0)),
//                                iconHeight: Int(viewPortHeight * (80 / 834.0)),
//                                bgColor: "F7F5F0",
//                                bgTransparency: 1.0,
//                                fontColor: "000000",
//                                fontTransparency: 1.0,
//                                cornerRadius: 20,
//                                isSystemImage: false,
//                                action: {
//                                    selectedRuangan = "RuangBermain"
//                                    shouldNavigate = true
//                                    speakText(selectedRuangan)
//
//                                }
//                            )
//                           
//                        }
////                        ForEach(Array(self.ruangan.enumerated()), id: \.offset) { i, ruangan in
////                            ActivityCard(
////                                icon: "", // Assuming `ruangan` has an image
////                                nomor: "",
////                                text: ruangan.name,
////                                width: Int((viewPortWidth * 0.75 - 290) / 4),
////                                height: Int(viewPortWidth * (180 / 1210.0)),
////                                font: Int(viewPortWidth * (15 / 1210.0)),
////                                iconWidth: Int(viewPortWidth * (80 / 1210.0)),
////                                iconHeight: Int(viewPortHeight * (80 / 834.0)),
////                                bgColor: "F7F5F0",
////                                bgTransparency: 1.0,
////                                fontColor: "000000",
////                                fontTransparency: 1.0,
////                                cornerRadius: 20,
////                                isSystemImage: false
////                            )
////                            .onTapGesture {
////                                selectedRuangan = ruangan.name
////                                shouldNavigate = true
////                            }
////                        }
//
//                    }
//                    .frame(width: viewPortWidth * 0.75, height: viewPortHeight * 0.6)
//
//                    
//                }
//                Spacer()
//            }
//            .frame(width: viewPortWidth * 0.9, height: viewPortHeight * 0.80)
//            .background(
//                RoundedRectangle(cornerRadius: 30)
//                    .fill(Color(hex: "BDD4CE", transparency: 1.0))
//                
//            )
//            NavigationLink(
//                destination: destinationForSelectedRuangan(),
//                isActive: $shouldNavigate
//            ) {
//                EmptyView()
//            }
//            
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(hex: "FBFBFB", transparency: 1.0))
//        .navigationBarBackButtonHidden(true)
//    }
//    
//    func destinationForSelectedRuangan() -> some View {
//        switch selectedRuangan {
//        case "RuangMakan":
//            return AnyView(AACRuangMakanView())
//        case "KamarMandi":
//            return AnyView(AACKamarMandiView())
//        case "RuangBelajar":
//            return AnyView(AACRuangBelajarView())
//        case "RuangBermain":
//            return AnyView(AACRuangBermainView())
//        case "Settings":
//            return AnyView(SettingsView())
//        default:
//            return AnyView(EmptyView())
//        }
//    }
//    
//    private func speakText(_ text: String) {
//        // Stop any ongoing speech
//        if speechSynthesizer.isSpeaking {
//            speechSynthesizer.stopSpeaking(at: .immediate)
//        }
//        
//        // Create a speech utterance
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID") // Set the language as needed
//        
//        // Speak the text
//        speechSynthesizer.speak(utterance)
//    }
//    
//    func resolveIcon(for iconName: String) -> String {
//        if let _ = UIImage(named: iconName) {
//            return iconName
//        } else if let _ = UIImage(named: iconName.uppercased()) {
//            return iconName.uppercased()
//        } else if let _ = UIImage(named: iconName.lowercased()) {
//            return iconName.lowercased()
//        } else {
//            // Fallback option if no icon is found
//            return "defaultIcon" // You can define a default icon
//        }
//    }
//}
//
//#Preview {
//    AACMenuView()
//}
