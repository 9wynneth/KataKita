//
//  PECSViewModel.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 05/11/24.
//

import Foundation

//TODO: To manage list of card that used in PECS
//TODO: Dijadiin singleton dulu biar bisa dipake buat view

@Observable
class PECSViewModel {
    
    var cards: [[Card]]
    
    init(cards: [[Card]] = [[]]) {
        self.cards = cards
    }
    
    // Column are used for adding in certain column (different card category = different column)
    func addCard(_ card: Card) {
        if card.category == .CORE {
            self.cards[0].append(card)
        } else if let index = self.cards.firstIndex(where: { $0.contains(where: { $0.category == card.category }) }) {
            self.cards[index].append(card)
        } else if let index = self.cards.firstIndex(where: { $0.isEmpty }) {
            self.cards[index].append(card)
        }
    }
    
    func removeCard(column: Int, row: Int) {
        self.cards[column].remove(at: row)
    }
}
