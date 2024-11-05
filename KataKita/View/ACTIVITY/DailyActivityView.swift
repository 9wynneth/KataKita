//
//  DailyActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 10/10/24& Edited by Alvito Dwi Heldy Muhammad on 17/10/2024.
//
import SwiftUI
import AVFoundation

///
struct DailyActivityView: View {
    @Environment(ScheduleManager.self) private var scheduleManager
    @Environment(\.dismiss) var dismiss
    @Environment(StateManager.self) private var stateManager
    
    private let speechSynthesizer = AVSpeechSynthesizer()

    @State private var selectedRuangan: String = ""
    @State private var isSetting: Bool = false
    @State private var isRuangan: Bool = false
    
    @State private var currentIndex: Int = 0
    @State private var shouldNavigate: Bool = false
    
    //MARK: viewport size
    let viewPortWidth = UIScreen.main.bounds.width
    let viewPortHeight = UIScreen.main.bounds.height
    
    /// Computed property
    var selectedDay: Day {
        let day = Date().dayNumberOfWeek()
        switch day {
        case 0:
            return .SUNDAY([])
        case 1:
            return .MONDAY([])
        case 2:
            return .TUESDAY([])
        case 3:
            return .WEDNESDAY([])
        case 4:
            return .THURSDAY([])
        case 5:
            return .FRIDAY([])
        default:
            return .SATURDAY([])
        }
    }
    
    var day: Day {
        return self.scheduleManager.schedules.first(where: { $0.day == self.selectedDay })?.day ?? self.selectedDay
    }
    var dayToString: String {
        let day = Date().dayNumberOfWeek()
        switch day {
        case 0:
            return "Minggu"
        case 1:
            return "Senin"
        case 2:
            return "Selasa"
        case 3:
            return "Rabu"
        case 4:
            return "Kamis"
        case 5:
            return "Jumat"
        default:
            return "Sabtu"
        }
    }
    
    var extractActivity: [Activity] {
        return self.day.extractActivities()
    }
    var steps: [Step] {
        return self.extractActivity[safe: self.stateManager.index]?.sequence ?? []
    }
    
    var isCompleted: Bool {
        return self.extractActivity.count <= self.stateManager.index
    }
    
    
    var body: some View {
        VStack (spacing: 0) {
            //MARK: - Header
            HStack (alignment: .top , spacing: 15) {
                VStack (alignment: .leading) {
                    TextHeadline(
                        text: "Kegiatan Lucas",
                        size: 36,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                    )
                    TextContent(
                        text: "Hari \(self.dayToString),",
                        size: 24,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                    )
                }
                Spacer()
                
                CustomButton(
                    icon: "keyboard",
                    width: 70,
                    height: 70,
                    font: 50,
                    iconWidth: 30,
                    iconHeight: 30,
                    bgColor: "F7F5F0",
                    bgTransparency: 1.0,
                    fontColor: "696767",
                    fontTransparency: 1.0,
                    cornerRadius: 20,
                    action: {
                        shouldNavigate = true
                        
                    }
                )
                
                
                CustomButton(
                    icon: "house.fill",
                    width: 70,
                    height: 70,
                    font: 50,
                    iconWidth: 30,
                    iconHeight: 30,
                    bgColor: "F7F5F0",
                    bgTransparency: 1.0,
                    fontColor: "696767",
                    fontTransparency: 1.0,
                    cornerRadius: 20,
                    action: {
                        dismiss()
                    }
                )
                
                NavigationLink(destination: SettingsView()){
                    CustomButton(
                        icon: "gearshape.fill",
                        width: 70,
                        height: 70,
                        font: 50,
                        iconWidth: 30,
                        iconHeight: 30,
                        bgColor: "F7F5F0",
                        bgTransparency: 1.0,
                        fontColor: "696767",
                        fontTransparency: 1.0,
                        cornerRadius: 20,
                        action: {
                            selectedRuangan = "Settings"
                            shouldNavigate = true
                        }
                    )
                }
                
            }
            .padding(.horizontal, 50)
            .frame(width: viewPortWidth, height: viewPortHeight * 0.15)
            
            
            //MARK: - Body
            HStack (alignment: .top , spacing: 50) {
                //MARK: viewport kiri (List kegiatan hari ini)
                LazyVStack (alignment: .center, spacing: 0) {
                    ForEach(Array(self.extractActivity.enumerated()), id: \.offset) { index, activity in
                        if self.stateManager.index <= index {
                            
                            ActivityCard(
                                icon: "\(activity.image)",
                                nomor: "",
                                text: "\(activity.name)",
                                width: Int((viewPortWidth * 0.75 - 290) / 4),
                                height: Int(viewPortWidth * (180 / 1210.0)),
                                font: Int(viewPortWidth * (25 / 1210.0)),
                                iconWidth: Int(viewPortWidth * (90 / 1210.0)),
                                iconHeight: Int(viewPortHeight * (90 / 834.0)),
                                bgColor: "BDD4CE",
                                bgTransparency: index == self.stateManager.index ? 1.0 : 0,
                                fontColor: "000000",
                                fontTransparency: 1.0,
                                cornerRadius: 20,
                                isSystemImage: false,
                                action: {
                                    speakText(activity.name)
                                }
                            )
                            
                        } else {
                            EmptyView()
                        }
                        
                    }
                    
                }
                .padding(.vertical, 30)
                .frame(width: viewPortWidth * 0.25 - 50)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "F7F5F0", transparency: 1.0))
                )
                
                
                
                // MARK: Viewport bagian kanan (Tahapan aktivitas)
                ScrollViewReader { proxy in
                HStack {
                        VStack (alignment: .leading, spacing: 20) {
                            TextHeadline(
                                text: "Tahapan aktivitas",
                                size: 24,
                                color: "Black",
                                transparency: 1.0,
                                weight: "Light"
                            )
                            if self.isCompleted {
                                Spacer()
                                TextContent(
                                    text: "Kamu telah menyelesaikan aktivitasmu!",
                                    size: 24,
                                    color: "Black",
                                    transparency: 1.0,
                                    weight: "Light"
                                )
                                .frame(maxWidth: .infinity)
                                Spacer()
                            } else {
                                ScrollView{
                                    LazyVGrid(
                                        columns: [
                                            GridItem(.flexible()),
                                            GridItem(.flexible()),
                                            GridItem(.flexible()),
                                            GridItem(.flexible()),
                                        ],
                                        spacing: 30
                                    ) {
                                        
                                        ForEach(Array(self.steps.enumerated()), id: \.offset) { i, step in
                                            ActivityCard(
                                                icon: "\(step.image)",
                                                nomor: "\(i + 1)",
                                                text: step.description,
                                                width: Int((viewPortWidth * 0.75 - 290) / 4), height: Int(viewPortWidth * (180 / 1210.0)),
                                                font: Int(viewPortWidth * (15 / 1210.0)), iconWidth: Int(viewPortWidth * (80 / 1210.0)), iconHeight: Int(viewPortHeight * (80 / 834.0)),
                                                bgColor: "F7F5F0", bgTransparency: 1.0,
                                                fontColor: "000000", fontTransparency: 1.0,
                                                cornerRadius: 20, isSystemImage: false,
                                                action: {
                                                    speakText(step.description)
                                                }
                                            )
                                            
                                            
                                        }
                                    }
                                    .padding(.bottom, 160)
                                }
                            }
                            
                            
                        }
                        .padding(50)
                        .frame(width: viewPortWidth * 0.75 - 100, height: viewPortHeight * 0.85 - 50, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(hex: "BDD4CE", transparency: 1.0))
                            
                        )
                        .overlay(
                            VStack (spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "BDD4CE", transparency: 0), Color(hex: "BDD4CE", transparency: 1.0)],
                                            startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(height: 60)
                                
                                if self.isCompleted {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(hex: "BDD4CE", transparency: 1.0))
                                        .frame(height: 100)
                                } else {
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(hex: "BDD4CE", transparency: 1.0))
                                        .frame(height: 100)
                                        .overlay(
                                            CustomButtonSide(
                                                icon: resolveIcon(for: "SELESAI 1"),
                                                text: "Selesai",
                                                width: 250,
                                                height: 80,
                                                font: 28,
                                                iconWidth: 55,
                                                iconHeight: 55,
                                                bgColor: "#F7F5F0",
                                                bgTransparency: 1.0,
                                                fontColor: "#000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 20,
                                                isSystemImage: false,
                                                action: {
                                                    self.stateManager.increment()
                                                    selectedRuangan = ""
                                                    if self.stateManager.index < self.extractActivity.count {
                                                        selectedRuangan = self.extractActivity[self.stateManager.index].ruangan.name
                                                        let currentActivity = self.extractActivity[self.stateManager.index]
                                                        speakText(currentActivity.name)
                                                    } else {
                                                        selectedRuangan = getSelectedRuangan()
                                                    }
                                                    proxy.scrollTo(0, anchor: .top)
                                                })
                                            
                                            //                                    CustomButtonSide(
                                            //                                        icon: "SELESAI 1",
                                            //                                        text: "Selesai",
                                            //                                        width: 150,
                                            //                                        height: 50,
                                            //                                        font: 14,
                                            //                                        bgColor: "#013C5A",
                                            //                                        bgTransparency: 1.0,
                                            //                                        fontColor: "#F7F5F0",
                                            //                                        fontTransparency: 1.0,
                                            //                                        cornerRadius: 20,
                                            //                                        action: {
                                            //                                            self.stateManager.increment()
                                            //                                            selectedRuangan = ""
                                            //                                            if self.stateManager.index < self.extractActivity.count {
                                            //                                                selectedRuangan = self.extractActivity[self.stateManager.index].ruangan.name
                                            //                                                let currentActivity = self.extractActivity[self.stateManager.index]
                                            //                                                speakText(currentActivity.name)
                                            //                                            } else {
                                            //                                                selectedRuangan = getSelectedRuangan() // Fallback to the top one
                                            //                                            }
                                            //                                        }
                                            //
                                            //                                    )
                                            
                                        )
                                    
                                    //                            VStack {
                                    //                                Text("Selected Ruangan: \(selectedRuangan)")
                                    //                                    .padding()
                                    //
                                    //                                // Existing views
                                    //                            }
                                }
                            }
                            
                        )
                        // Button for scroll
                        VStack {
                            CustomButton(
                                icon: "arrowtriangle.up",
                                width: 40,
                                height: 40,
                                font: 24,
                                iconWidth: 20,
                                iconHeight: 20,
                                bgColor: "000000",
                                bgTransparency: 0,
                                fontColor: "#000000",
                                fontTransparency: self.isCompleted ? 0.0 : 1.0,
                                cornerRadius: 20,
                                isSystemImage: true,
                                
                                action: {
                                    withAnimation {
                                        let newIndex = max(currentIndex - 4, 0)
                                        proxy.scrollTo(newIndex, anchor: .top)
                                        currentIndex = newIndex
                                        print(currentIndex)
                                    }
                                }
                            )
                            
                            CustomButton(
                                icon: "arrowtriangle.down",
                                width: 40,
                                height: 40,
                                font: 24,
                                iconWidth: 20,
                                iconHeight: 20,
                                bgColor: "000000",
                                bgTransparency: 0,
                                fontColor: "#000000",
                                fontTransparency: self.isCompleted ? 0.0 : 1.0,
                                cornerRadius: 20,
                                isSystemImage: true,
                                action: {
                                    withAnimation {
                                        let stepsCount = steps.count

                                        // Calculate the maximum index allowed
                                        let maxIndex = stepsCount - 1

                                        // Calculate the desired index (move forward by 2)
                                        let calculatedIndex = currentIndex + 4

                                        // Ensure the index doesn't exceed the maximum valid index
                                        let newIndex = min(calculatedIndex, maxIndex)

                                        // Scroll to the new index in the scroll proxy
                                        proxy.scrollTo(newIndex, anchor: .top)
                                        
                                        // Update the current index
                                        currentIndex = newIndex
                                        print(currentIndex)
                                    }
                                }
                                
                            )
                            
                        }
                    }
                }
            }
            .padding(.horizontal, 50)
            .frame(width: viewPortWidth, height: viewPortHeight * 0.85, alignment: .topLeading)
        }
        .frame(width: viewPortWidth, height: viewPortHeight)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            // statemanager
            if self.stateManager.index < self.extractActivity.count {
                selectedRuangan = self.extractActivity[self.stateManager.index].ruangan.name
                
                let currentActivity = self.extractActivity[self.stateManager.index]
                speakText(currentActivity.name)
            } else {
                selectedRuangan = getSelectedRuangan() // Fallback to the top one
            }
          
        }
//        NavigationLink(
//            destination: destinationForSelectedRuangan(),
//            isActive: $shouldNavigate
//        ) {
//            EmptyView()
//        }
        
    }
    
    func getSelectedRuangan() -> String {
        if let firstActivity = extractActivity.first {
            return firstActivity.ruangan.name
        }
        return ""
    }
//    func destinationForSelectedRuangan() -> some View {
//        switch selectedRuangan {
//        case "RuangMakan":
//            return AnyView(AACRuangMakanView())
//        case "KamarMandi":
//            return AnyView(AACKamarMandiView())
//        case "RuangBelajar":
//            return AnyView(AACRuangBelajarView())
//        case "Settings":
//            return AnyView(SettingsView())
//        default:
//            return AnyView(EmptyView())
//        }
//    }
    
    private func speakText(_ text: String) {
            // Stop any ongoing speech
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
            
            // Create a speech utterance
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "id-ID") // Set the language as needed
            
            // Speak the text
            speechSynthesizer.speak(utterance)
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

//#Preview {
//    DailyActivityView()
//}