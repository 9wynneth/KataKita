//
//  SpeechManager.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 07/11/24.
//

import AVFoundation

class SpeechManager {
    static let shared = SpeechManager()  // Singleton instance
    let synthesizer = AVSpeechSynthesizer()
    
    private init() {}  
    
    func speakCardNamePECS(_ card: Card) {
        stopSpeech()
        
        let localizedName = NSLocalizedString(card.name, comment: "Concatenated text for speech synthesis")
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"
        
        let utterance = AVSpeechUtterance(string: localizedName)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        
        //        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func speakAllTextPECS(for cards: [Card]) {
        stopSpeech()
        
        let fullText = cards.map { NSLocalizedString($0.name, comment: "Card name for speech synthesis") }.joined(separator: ", ")
        
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU"
        
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        
        //        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func speakCardAAC(_ text: String) {
        stopSpeech()
        // Menggunakan NSLocalizedString untuk mendapatkan string yang dilokalkan
        let localizedText = NSLocalizedString(text, comment: "")
        // Memeriksa bahasa perangkat
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        let voiceLanguage = lang == "id" ? "id-ID" : "en-AU"
        
        let utterance = AVSpeechUtterance(string: localizedText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    func speakAllTextAAC(from buttons: [Card]) {
        stopSpeech()
        var fullText = ""
        for card in buttons {
            // Menggunakan NSLocalizedString untuk setiap nama kartu
            let localizedName = NSLocalizedString(card.name, comment: "")
            fullText += "\(localizedName) "
        }
        
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        let voiceLanguage = lang == "id" ? "id-ID" : "en-AU"
        
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    func stopSpeech() {
        if self.synthesizer.isSpeaking {
            self.synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
}
