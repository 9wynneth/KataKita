//
//  SpeechManager.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 07/11/24.
//

import AVFoundation

class SpeechManager {
    static let shared = SpeechManager()  // Singleton instance

    private init() {}  // Private initializer to enforce singleton

    // Function to speak a single card's name
    func speakCardName(_ card: Card) {
        let localizedName = NSLocalizedString(card.name, comment: "Concatenated text for speech synthesis")
        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU" // Set the voice language based on device language
        
        // Create an utterance for the card name
        let utterance = AVSpeechUtterance(string: localizedName)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage) // Set voice based on device language
        
        // Use the AVSpeechSynthesizer to speak the card name
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    // Function to speak the names of multiple cards
    func speakText(for cards: [Card]) {
        // Concatenate all the card names into a single text
        let fullText = cards.map { NSLocalizedString($0.name, comment: "Card name for speech synthesis") }.joined(separator: ", ")
        
        // Detect device language
        let languageCode = Locale.current.languageCode
        let voiceLanguage = languageCode == "id" ? "id-ID" : "en-AU" // Set the voice language based on device language
        
        // Create an utterance for the concatenated text
        let utterance = AVSpeechUtterance(string: fullText)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage) // Set voice based on device language
        
        // Use the AVSpeechSynthesizer to speak the full text
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

}
