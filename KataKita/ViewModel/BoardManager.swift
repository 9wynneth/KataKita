//
//  BoardManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI

class BoardManager {
    var boards: [Board]
    var selectedID: UUID?
    
    init(_ boards: [Board] = []) {
        if boards.isEmpty {
            self.boards = [
                Board(
                    cards: [
                        Card(name: "Aku", icon: "ball", category: .CORE),
                        Card(name: "Kamu", icon: "ball", category: .CORE),
                        Card(name: "Kita", icon: "ball", category: .CORE),
                        Card(name: "Jancok", icon: "ball", category: .CORE)
                    ],
                    name: "Ruang Makan",
                    gridSize: Grid(row: 4, column: 7 )
                )
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
    func addCard(_ card: Card) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: {$0.id == id} ) {
            self.boards[index].cards.append(card)
        }
    }
    
    func removeCard(_ cardID: UUID) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: { $0.id == id } ) {
            self.boards[index].cards.removeAll(where: { $0.id == cardID })
        }
    }
}

