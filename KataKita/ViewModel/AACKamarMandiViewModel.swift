//
//  AACKamarMandiViewModel.swift
//  KataKita
//
//  Created by Lisandra Nicoline on 18/10/24.
//

import SwiftUI

class AACKamarMandiViewModel: ObservableObject {
    @Published var cards: [[Card]] = []

    init() {
        loadCardsData()
    }

    // Function to load the data and convert it to Card models
    func loadCardsData() {
        let rawData = [
            [("person.fill", "aku", "#FFEBAF", "#000000"), ("person.fill", "kamu", "#FFEBAF", "#000000"), ("person.fill", "dia", "#FFEBAF", "#000000"), ("person.fill", "kita", "#FFEBAF", "#000000"), ("person.fill", "teman", "#FFEBAF", "#000000")],
            [("person.fill", "apa", "#A77DFF", "#000000"), ("person.fill", "dimana", "#A77DFF", "#000000"), ("person.fill", "kenapa", "#A77DFF", "#000000"), ("person.fill", "kapan", "#A77DFF", "#000000"), ("person.fill", "bagaimana", "#A77DFF", "#000000")],
            [("person.fill", "mau", "#FFB0C7", "#000000"), ("person.fill", "iya", "#FFB0C7", "#000000"), ("person.fill", "tidak", "#FFB0C7", "#000000"), ("person.fill", "selesai", "#FFB0C7", "#000000"), ("person.fill", "tolong", "#FFB0C7", "#000000")],
            [("person.fill", "pipis", "#CFF0C8", "#000000"), ("person.fill", "pup", "#CFF0C8", "#000000"), ("person.fill", "mandi", "#CFF0C8", "#000000"), ("person.fill", "sikat gigi", "#CFF0C8", "#000000"), ("person.fill", "cuci tangan", "#CFF0C8", "#000000")],
            [("person.fill", "sikat", "#CFF0C8", "#000000"), ("person.fill", "kumur", "#CFF0C8", "#000000"), ("person.fill", "gosok", "#CFF0C8", "#000000"), ("person.fill", "lap", "#CFF0C8", "#000000"), ("person.fill", "siram", "#CFF0C8", "#000000")],
            [("person.fill", "keras", "#D4F3FF", "#000000"), ("person.fill", "berat", "#D4F3FF", "#000000"), ("person.fill", "panas", "#D4F3FF", "#000000"), ("person.fill", "dingin", "#D4F3FF", "#000000") , ("person.fill", "licin", "#D4F3FF", "#000000")],
            [("person.fill", "sampo", "#F2B95C", "#000000"), ("person.fill", "sabun", "#F2B95C", "#000000"), ("person.fill", "odol", "#F2B95C", "#000000"), ("person.fill", "sikat gigi", "#F2B95C", "#000000"), ("person.fill", "handuk", "#F2B95C", "#000000")],
            [("person.fill", "baju", "#F2B95C", "#000000"), ("person.fill", "celana", "#F2B95C", "#000000"), ("person.fill", "air", "#F2B95C", "#000000"), ("person.fill", "gelas", "#F2B95C", "#000000"), ("person.fill", "shower", "#F2B95C", "#000000")],
            [("person.fill", "hitam", "#000000", "#000000"), ("person.fill", "cokelat", "#835737", "#835737"), ("person.fill", "oranye", "#E9AE50", "#E9AE50"), ("person.fill", "merah", "#E54646", "#E54646"), ("person.fill", "ungu", "#B378D8", "#B378D8"), ("person.fill", "pink", "#EDB0DC", "#EDB0DC"), ("person.fill", "biru", "#889AE4", "#889AE4"), ("person.fill", "hijau", "#B7D273", "#B7D273"), ("person.fill", "kuning", "#EFDB76", "#EFDB76")]
        ]
        
        var loadedCards: [[Card]] = []
        
        for (index, dataSet) in rawData.enumerated() {
            var cardsInRow: [Card] = []
            for data in dataSet {
                let icon = data.0
                let name = data.1
                let backgroundColor = data.2
                let fontColor = data.3
                
                // Create a Category for each row with the background and font color
                let category = Category(name: "Category \(index + 1)", color: backgroundColor, fontColor: fontColor)
                
                // Create the card
                let card = Card(icon: icon, name: name, category: category)
                
                cardsInRow.append(card)
            }
            loadedCards.append(cardsInRow)
        }
        
        self.cards = loadedCards
    }
    
    func addCard(icon: String, text: String, backgroundColor: String) {
        // Create a new category for this card (you can adjust this logic)
        let category = Category(name: "New Category", color: backgroundColor, fontColor: "#000000") // Default font color

        // Create the new card
        let newCard = Card(icon: icon, name: text, category: category)
                cards.append([newCard])
                print("Added card: \(newCard)")

        // Add the new card to the first row for simplicity (adjust this logic as needed)
        if !cards.isEmpty {
            // Adding to the first row, modify if necessary
            cards[0].append(newCard)
        } else {
            // If no rows exist, create the first row with the new card
            cards.append([newCard])
        }
        
    }
}
