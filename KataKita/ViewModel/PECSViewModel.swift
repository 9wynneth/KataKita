//
//  PECSViewModel.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 05/11/24.
//

import Foundation

//TODO: To manage list of card that used in PECS
//TODO: Dijadiin singleton dulu biar bisa dipake buat view
class PECSViewModel {
    static var shared: PECSViewModel = PECSViewModel()
    var cards: [[Card]]

    private init(cards: [[Card]] = [[]]) {
        self.cards = cards
    }
    // Column are used for adding in certain column
    func addCard(_ card: Card, column: Int) {
        self.cards[column].append(card)
    }
    
    func removeCard(column: Int, row: Int) {
        self.cards[column].remove(at: row)
    }
}
