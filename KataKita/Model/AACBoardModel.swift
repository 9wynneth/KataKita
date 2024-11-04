//import SwiftUI
//
//class Category: Identifiable, ObservableObject, Hashable, Equatable {
//    let id: UUID = UUID()
//    var name: String
//    @Published var color: String // Hex color
//    @Published var fontColor: String // Font color
//
//    init(name: String, color: String, fontColor: String) {
//        self.name = name
//        self.color = color
//        self.fontColor = fontColor
//    }
//
//    static func == (lhs: Category, rhs: Category) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//class Card: Identifiable, Equatable, Hashable {
//    let id: UUID = UUID()
//    let icon: String // SF Symbol
//    let name: String
//    var category: Category
//
//    init(icon: String, name: String, category: Category) {
//        self.icon = icon
//        self.name = name
//        self.category = category
//    }
//    static func == (lhs: Card, rhs: Card) -> Bool {
//        return lhs.id == rhs.id
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//class AACBoardModel: ObservableObject {
//    @Published var categories: [Category] = []
//    @Published var cards: [Card] = []
//    
//    // Function to add a new category
//    func addCategory(name: String, color: String, fontColor: String) {
//        let newCategory = Category(name: name, color: color, fontColor: fontColor)
//        categories.append(newCategory)
//    }
//
//    // Function to save category color
//    func saveCategoryColor(for categoryId: UUID, color: String) {
//        if let index = categories.firstIndex(where: { $0.id == categoryId }) {
//            categories[index].color = color
//        }
//    }
//}
//
//class LessonViewModel: ObservableObject {
//    @Published var selectedCardLesson: [Card] = []
//}
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
    @Published var icon: String // SF Symbol
    @Published var name: String
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
