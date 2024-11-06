//
//  BoardManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI

class BoardManager {
    static var shared = BoardManager()
    var boards: [Board]
    var selectedID: UUID?
    
    init(_ boards: [Board] = []) {
        if boards.isEmpty {
            self.boards = [
                Board(
                    cards: [
                        [
                            Card(name: "Aku", icon: "saya", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                            Card(name: "Mereka", icon: "mereka", category: .CORE, isIconTypeImage: false)
                        ],
                        [
                            Card(name: "Di atas", icon: "di atas", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Terima kasih", icon: "terima kasih", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                    ],
                    name: "Ruang Makan",
                    gridSize: Grid(row: 4, column: 5 )
                ),
                Board(
                    cards: [
                        [
                            Card(name: "Aku", icon: "saya", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                            Card(name: "Mereka", icon: "mereka", category: .CORE, isIconTypeImage: false),
                            Card(name: "Ayah", icon: "ayah", category: .CORE, isIconTypeImage: false)
                        ],
                        [
                            Card(name: "Di atas", icon: "di atas", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Terima kasih", icon: "terima kasih", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [],
                        [],
                        []
                    ],
                    name: "Ruang Nentod",
                    icon: "ASTRONOT",
                    gridSize: Grid(row: 5, column: 8)
                ),
                Board(
                    cards: [
                        [
                            Card(name: "Aku", icon: "saya", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                            Card(name: "Kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                            Card(name: "Mereka", icon: "mereka", category: .CORE, isIconTypeImage: false),
                            Card(name: "Ayah", icon: "ayah", category: .CORE, isIconTypeImage: false)
                        ],
                        [
                            Card(name: "Di atas", icon: "di atas", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Terima kasih", icon: "terima kasih", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                            Card(name: "Suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [
                            Card(name: "Apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                            Card(name: "Kenapa", icon: "kenapa", category: .QUESTION, isIconTypeImage: false),
                        ],
                        [],
                        [],
                        []
                    ],
                    name: "Ruang Ngocok",
                    icon: "PRINT",
                    gridSize: Grid(row: 5, column: 8)
                ),
            ]
        }
        else {
            self.boards = boards
        }
        self.selectedID = nil
    }
    
    //MARK: default value (isi value bawaan dari kita)
    private func populateBoard() -> [Board] {
        return []
    }
    
    func selectId(_ id: UUID) {
        self.selectedID = id
    }
    
    //MARK: CRUD Board
    func addBoard(_ board: Board) {
        boards.append(board)
    }
    func removeBoard() {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: {$0.id == id} ) {
            self.boards.remove(at: index)
        }
    }
    
    //MARK: CRUD Card
    func addCard(_ card: Card, column: Int) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: {$0.id == id} ) {
            self.boards[index].cards[column].append(card)
        }
    }
    
    func removeCard( column: Int, row: Int) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: { $0.id == id } ) {
            self.boards[index].cards[column].remove(at: row)
        }
    }
}

