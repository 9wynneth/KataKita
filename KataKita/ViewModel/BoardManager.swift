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
                            Card(name: "Aku", icon: "ball", category: .CORE),
                            Card(name: "Kamu", icon: "ball", category: .CORE),
                            Card(name: "Kita", icon: "ball", category: .CORE),
                            Card(name: "Mereka", icon: "ball", category: .CORE)
                        ],
                        [
                            Card(name: "Di atas", icon: "ball", category: .SOCIAL),
                            Card(name: "Terima kasih", icon: "ball", category: .SOCIAL),
                            Card(name: "Tidak", icon: "ball", category: .SOCIAL),
                            Card(name: "Suka", icon: "ball", category: .SOCIAL),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                    ],
                    name: "Ruang Makan",
                    gridSize: Grid(row: 4, column: 5 )
                ),
                Board(
                    cards: [
                        [
                            Card(name: "Aku", icon: "ball", category: .CORE),
                            Card(name: "Kamu", icon: "ball", category: .CORE),
                            Card(name: "Kita", icon: "ball", category: .CORE),
                            Card(name: "Mereka", icon: "ball", category: .CORE),
                            Card(name: "Ayah", icon: "ball", category: .CORE)
                        ],
                        [
                            Card(name: "Di atas", icon: "ball", category: .SOCIAL),
                            Card(name: "Terima kasih", icon: "ball", category: .SOCIAL),
                            Card(name: "Tidak", icon: "ball", category: .SOCIAL),
                            Card(name: "Suka", icon: "ball", category: .SOCIAL),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
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
                            Card(name: "Aku", icon: "ball", category: .CORE),
                            Card(name: "Kamu", icon: "ball", category: .CORE),
                            Card(name: "Kita", icon: "ball", category: .CORE),
                            Card(name: "Mereka", icon: "ball", category: .CORE),
                            Card(name: "Ayah", icon: "ball", category: .CORE)
                        ],
                        [
                            Card(name: "Di atas", icon: "ball", category: .SOCIAL),
                            Card(name: "Terima kasih", icon: "ball", category: .SOCIAL),
                            Card(name: "Tidak", icon: "ball", category: .SOCIAL),
                            Card(name: "Suka", icon: "ball", category: .SOCIAL),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
                        ],
                        [
                            Card(name: "Apa", icon: "ball", category: .QUESTION),
                            Card(name: "Siapa", icon: "ball", category: .QUESTION),
                            Card(name: "Kapan", icon: "ball", category: .QUESTION),
                            Card(name: "Kenapa", icon: "ball", category: .QUESTION),
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

