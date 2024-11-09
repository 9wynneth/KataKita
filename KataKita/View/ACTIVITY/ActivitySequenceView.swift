//
//  ActivitySequenceView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//

import SwiftUI
import AVFoundation


struct ActivitySequenceView: View {
    var steps: [String]
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @Binding var selectedActivity: String
    @State private var buttonDoneCliked: Bool = false
    
    
    var body: some View {
        let items = Array(1...10).map { "\($0)"}
        
        VStack {
            
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))]) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        ActivityCard(
                            icon: "ball",
                            nomor: "\(index + 1)",
                            text: steps[index],
                            width: Int(screenWidth * (180 / 1210.0)), height: Int(screenWidth * (180 / 1210.0)),
                            font: Int(screenWidth * (15 / 1210.0)), iconWidth: Int(screenWidth * (50 / 1210.0)), iconHeight: Int(screenHeight * (50 / 834.0)),
                            bgColor: "F7F5F0", bgTransparency: 1.0,
                            fontColor: "000000", fontTransparency: 1.0,
                            cornerRadius: 20, isSystemImage: false,
                            action: {
                                speakText(steps[index])
                            }
                        )
                        .padding(8)
                        
                    }
                    
                    Spacer()
                }
                .padding()
                
                
            }
            .padding()
            .onAppear{
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
            }
            
        }
    }
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Speak function
    func speakText(_ text: String) {
        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU" // Set voice language based on device language
        
        // Create the speech utterance
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage) // Set the language accordingly
        utterance.rate = 0.5 // Set the speech rate

        // Speak the text
        speechSynthesizer.speak(utterance)
    }

    
}


//#Preview {
//    ActivitySequenceView(steps: [
//        "Ambil sikat gigi",
//        "Ambil pasta gigi",
//        "Tuangkan pasta gigi",
//        "Mulai menyikat gigi",
//        "Kumur air",
//        "Selesai"
//    ])
//}
