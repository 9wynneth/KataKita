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
        let utterance = AVSpeechUtterance(string: card.name)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    // Function to speak the names of multiple cards
    func speakText(for cards: [Card]) {
        let utterance = AVSpeechUtterance(string: cards.map { $0.name }.joined(separator: ", "))
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")  // Set the language if needed
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
