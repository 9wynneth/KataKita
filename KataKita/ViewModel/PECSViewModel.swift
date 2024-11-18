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
    var cards: [[Card]] {
        didSet {
            guard let data = try? JSONEncoder().encode(self.cards) else {
                return
            }

            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "pecs")
        }
    }
    
    init(cards: [[Card]] = [[], [], [], [], []]) {
        self.cards = cards
    }
    
    func load() {
        let defaults = UserDefaults.standard

        if let raw = defaults.object(forKey: "pecs") as? Data {
            guard let cards = try? JSONDecoder().decode([[Card]].self, from: raw) else { return }
            self.cards = cards
        }
    }
    
    func reset() {
        self.cards = [[], [], [], [], []]
    }
    
    func cardHandler(_ card: Card) {
        if let pos = self.getCardPos(card) {
            self.removeCard(column: pos.0, row: pos.1)
        } else {
            self.addCard(card)
        }
        self.cards = cards
    }

    private func getCardPos(_ card: Card) -> (Int, Int)? {
        for (colIndex, col) in self.cards.enumerated() {
            for (rowIndex, row) in col.enumerated() {
                if row.id == card.id {
                    return (colIndex, rowIndex)
                }
            }
        }

        return nil
    }

    private func addCard(_ card: Card) {
        if card.category == .CORE {
            if self.cards[0].count < 5 {
                self.cards[0].append(card)
            }
        } else if let index = self.cards.firstIndex(where: {
            $0.contains(where: { $0.category == card.category })
        }) {
            if self.cards[index].count < 5 {
                self.cards[index].append(card)
            }
        } else if let index = self.cards[1...].firstIndex(where: {
            $0.isEmpty
        }) {
            if self.cards[index].count < 5 {
                self.cards[index].append(card)
            }
        }
    }
    
    private func removeCard(column: Int, row: Int) {
        self.cards[column].remove(at: row)
    }
}
