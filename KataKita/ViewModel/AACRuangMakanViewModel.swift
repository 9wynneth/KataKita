import SwiftUI
import Combine

class AACRuangMakanViewModel: ObservableObject {
    @Published var cards: [[Card]] = []
    private var rawData: [[(String, String, String, String)]] = [
        [("saya", "saya", "#FFEBAF", "#000000"), ("kamu", "kamu", "#FFEBAF", "#000000"), ("dia", "dia", "#FFEBAF", "#000000"), ("kita", "kita", "#FFEBAF", "#000000"), ("ibu", "ibu", "#FFEBAF", "#000000"),
         ("ayah", "ayah", "#FFEBAF", "#000000")],
        [("apa", "apa", "#A77DFF", "#000000"), ("dimana", "dimana", "#A77DFF", "#000000"), ("kapan", "kapan", "#A77DFF", "#000000"), ("siapa", "siapa", "#A77DFF", "#000000")],
        [("suka", "suka", "#FFB0C7", "#000000"), ("tidak suka", "tidak suka", "#FFB0C7", "#000000"), ("mau", "mau", "#FFB0C7", "#000000"), ("tidak mau", "tidak mau", "#FFB0C7", "#000000"), ("tolong", "tolong", "#FFB0C7", "#000000")],
        [("makan", "makan", "#CFF0C8", "#000000"), ("minum", "minum", "#CFF0C8", "#000000"), ("putar", "putar", "#CFF0C8", "#000000"), ("buka", "buka", "#CFF0C8", "#000000"), ("tutup", "tutup", "#CFF0C8", "#000000"), ("masukkan", "masukkan", "#CFF0C8", "#000000")],
        [("ambil", "ambil", "#CFF0C8", "#000000"), ("kunyah", "kunyah", "#CFF0C8", "#000000"), ("potong", "potong", "#CFF0C8", "#000000"), ("buang", "buang", "#CFF0C8", "#000000")],
        [("dingin", "dingin", "#D4F3FF", "#000000"), ("panas", "panas", "#D4F3FF", "#000000"), ("Artboard 147", "asin", "#D4F3FF", "#000000"), ("manis", "manis", "#D4F3FF", "#000000")],
        [("sendok", "sendok", "#F2B95C", "#000000"), ("garpu", "garpu", "#F2B95C", "#000000"), ("piring", "piring", "#F2B95C", "#000000"), ("sup", "mangkok", "#F2B95C", "#000000"), ("gelas air", "gelas", "#F2B95C", "#000000"), ("kue kering", "kue kering", "#F2B95C", "#000000")],
        [("ayam goreng", "ayam goreng", "#F2B95C", "#000000"), ("nasi", "nasi", "#F2B95C", "#000000"), ("mie", "mie", "#F2B95C", "#000000"), ("susu", "susu", "#F2B95C", "#000000"), ("teh", "teh", "#F2B95C", "#000000"), ("roti", "roti", "#F2B95C", "#000000")],
        [("person.fill", "hitam", "#000000", "#000000"), ("person.fill", "cokelat", "#835737", "#835737"), ("person.fill", "oranye", "#E9AE50", "#E9AE50"), ("person.fill", "merah", "#E54646", "#E54646"), ("person.fill", "ungu", "#B378D8", "#B378D8"), ("person.fill", "pink", "#EDB0DC", "#EDB0DC"), ("person.fill", "biru", "#889AE4", "#889AE4"), ("person.fill", "hijau", "#B7D273", "#B7D273"), ("person.fill", "kuning", "#EFDB76", "#EFDB76")]
    ]

    init() {
        loadCardsData()
    }

    // Function to load the data and convert it to Card models
    func loadCardsData() {
        if cards.isEmpty {
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
    }
    
    func addCard(icon: String, text: String, backgroundColor: String, columnIndex: Int, rowIndex: Int) {
        // Create a new category for this card
        let category = Category(name: "New Category", color: backgroundColor, fontColor: "#000000") // Default font color

        // Create the new card
        let newCard = Card(icon: icon, name: text, category: category)
        print("Adding card at column \(columnIndex), row \(rowIndex): \(newCard)")
        
        // Check if the specified row exists in the cards array
        if rowIndex < cards.count {
            // Check if the specified column exists in the selected row
            if columnIndex < cards[rowIndex].count {
                // Insert the new card into the specified position
                cards[rowIndex].insert(newCard, at: columnIndex)
            } else {
                // If the column does not exist, append the card to the row
                cards[rowIndex].append(newCard)
            }
        } else {
            // If the row does not exist, create a new row and add the card to it
            cards.append([newCard])
        }
        
        // Trigger SwiftUI to recognize the change
        objectWillChange.send()
        self.cards = cards

        print("Updated cards data: \(cards)")
    }
}
