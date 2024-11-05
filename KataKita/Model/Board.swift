//
//  Board.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI
import SwiftData

enum Category: String, Codable {
    case CORE
    case QUESTION
    case SOCIAL
    case VERB
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
            case .NOUN:
                return .orange
            case .ADJECTIVE:
                return .gray
        }
    }
    func getColorString() -> String {
        switch self {
            case .CORE:
                return "FFEBAF"
            case .QUESTION:
                return "A77DFF"
            case .SOCIAL:
                return "FFB0C7"
            case .VERB:
                return "CFF0C8"
            case .NOUN:
                return "F2B95C"
            case .ADJECTIVE:
                return "D4F3FF"
        }
    }
}

struct Grid : Codable {
    var row: Int
    var column: Int
}

//MARK: Kartu yang ada pada board
struct Card: Identifiable, Codable {
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

class Board: Identifiable {
    var id: UUID
    var cards: [[Card]]
    var name: String
    var icon: String?
    var gridSize: Grid
     
    
    init(cards : [[Card]], name: String, icon: String? = nil, gridSize: Grid) {
        self.id = UUID()
        self.cards = cards
        self.name = name
        self.icon = icon
        self.gridSize = gridSize
    }
}
