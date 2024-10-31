//
//  Board.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI
import SwiftData

enum Category: String {
    case CORE
    case QUESTION
    case SOCIAL
    case VERB
    case PRONOUN
    case NOUN
    case ADJECTIVE
    
    func getColor() -> Color {
        switch self {
            case .CORE:
                return .yellow
            case .QUESTION:
                return .purple
            case .SOCIAL:
                return .red
            case .VERB:
                return .green
            case .PRONOUN:
                return .blue
            case .NOUN:
                return .orange
            case .ADJECTIVE:
                return .gray
        }
    }
}

struct Grid {
    var row: Int
    var column: Int
    
}

//MARK: Kartu yang ada pada board
struct Card: Identifiable {
    var id = UUID()
    var name: String
    var icon: String // SF Symbol
    var category: Category

    init(name: String, icon: String, category: Category) {
        self.icon = icon
        self.name = name
        self.category = category
    }
}

@Model
class Board: Identifiable {
    var id: UUID
    var cards: [Card]
    var name: String
    var icon: String?
    var gridSize: Grid
     
    
    init(cards : [Card], name: String, icon: String? = nil, gridSize: Grid) {
        self.id = UUID()
        self.cards = cards
        self.name = name
        self.icon = icon
        self.gridSize = gridSize
    }
}
