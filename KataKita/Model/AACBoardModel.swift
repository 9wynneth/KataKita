import SwiftUI

class Category: Identifiable, ObservableObject {
    let id: UUID = UUID()
    var name: String
    @Published var color: String // Hex color
    @Published var fontColor: String // Font color

    init(name: String, color: String, fontColor: String) {
        self.name = name
        self.color = color
        self.fontColor = fontColor
    }
}

class Card: Identifiable {
    let id: UUID = UUID()
    let icon: String // SF Symbol
    let name: String
    var category: Category

    init(icon: String, name: String, category: Category) {
        self.icon = icon
        self.name = name
        self.category = category
    }
}

class AACBoardModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var cards: [Card] = []
    
    // Function to add a new category
    func addCategory(name: String, color: String, fontColor: String) {
        let newCategory = Category(name: name, color: color, fontColor: fontColor)
        categories.append(newCategory)
    }

    // Function to save category color
    func saveCategoryColor(for categoryId: UUID, color: String) {
        if let index = categories.firstIndex(where: { $0.id == categoryId }) {
            categories[index].color = color
        }
    }
}