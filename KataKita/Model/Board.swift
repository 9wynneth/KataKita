//
//  Board.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI
import SwiftData
import UniformTypeIdentifiers


enum Category: String, Codable, CaseIterable {
    case CORE
    case QUESTION
    case SOCIAL
    case VERB
    case NOUN
    case ADJECTIVE
    case CONJUNCTION

    
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
                return .blue
            case .CONJUNCTION:
                return .white
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
            case .CONJUNCTION:
                return "FFFFFF"
        }
    }
}


struct Grid : Codable {
    var row: Int
    var column: Int
}

//MARK: Kartu yang ada pada board
struct Card: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var icon: String
    var category: Category
    var isImageType: Bool
    var isColorType: Bool
    var color: String?

       

    init(name: String, icon: String, category: Category, isImageType: Bool = false, isColorType: Bool = false, color: String? = nil) {        self.icon = icon
        self.name = name
        self.category = category
        self.isImageType = isImageType
        self.isColorType = isColorType
        self.color = color    }
   
    
    
}
extension UTType {
    static let cardType = UTType(exportedAs: "com.example.KataKita.card")
}

struct CardList: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var bgColor: Color  // Background color
    var bgTransparency: Double  // Background transparency
    var fontColor: Color
    var isImageType: Bool
}

@Model
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
