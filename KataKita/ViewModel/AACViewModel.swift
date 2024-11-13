//
//  AACViewModel.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 13/11/24.
//

import SwiftUI

@Observable
class AACViewModel {
    var cards: [Card]
    
    private var limit: Int {
        let spacing: CGFloat = 15
        let width: CGFloat = 50
        let space: CGFloat = UIScreen.main.bounds.width * 0.5
        
        return Int((space + spacing) / (width + spacing))
    }
    
    init(cards: [Card] = []) {
        self.cards = cards
    }
    
    func addCard(_ card: Card) -> Bool {
        if self.cards.count >= self.limit {
            return false
        }
        self.cards.append(card)
        return true
    }
    func clear() {
        self.cards.removeAll()
    }
}
