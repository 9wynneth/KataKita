//
//  BoardManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI
import SwiftData

@MainActor
@Observable
class BoardManager {
    private var model: ModelContext
    var boards: [Board]
    var selectedID: UUID?
    
    init(_ model: ModelContext) {
        self.model = model
        self.boards = []
        self.selectedID = nil
    }
    
    func load() {
        do {
            let descriptor = FetchDescriptor<Board>(sortBy: [SortDescriptor(\.id)])
            self.boards = try self.model.fetch(descriptor)
        } catch {
            self.boards = []
        }
    }
    func populate() {
        let datas = [
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isImageType: false),
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak mau", icon: "tidak mau", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "makan", icon: "makan", category: .VERB, isImageType: false),
                        Card(name: "minum", icon: "minum", category: .VERB, isImageType: false),
                        Card(name: "putar", icon: "putar", category: .VERB, isImageType: false),
                        Card(name: "buka", icon: "buka", category: .VERB, isImageType: false),
                        Card(name: "tutup", icon: "tutup", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "ambil", icon: "ambil", category: .VERB, isImageType: false),
                        Card(name: "kunyah", icon: "mengunyah", category: .VERB, isImageType: false),
                        Card(name: "potong", icon: "memotong", category: .VERB, isImageType: false),
                        Card(name: "buang", icon: "buang", category: .VERB, isImageType: false),
                        Card(name: "masukkan", icon: "MASUK", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "asin", icon: "asin", category: .ADJECTIVE, isImageType: false),
                        Card(name: "manis", icon: "manis", category: .ADJECTIVE, isImageType: false)
                    ],
                    [
                        Card(name: "sendok", icon: "sendok", category: .NOUN, isImageType: false),
                        Card(name: "garpu", icon: "garpu", category: .NOUN, isImageType: false),
                        Card(name: "piring", icon: "piring", category: .NOUN, isImageType: false),
                        Card(name: "mangkok", icon: "sup", category: .NOUN, isImageType: false),
                        Card(name: "air", icon: "gelas", category: .NOUN, isImageType: false)
                    ],
                    [
                        Card(name: "ayam goreng", icon: "ayam goreng", category: .NOUN, isImageType: false),
                        Card(name: "nasi", icon: "nasi", category: .NOUN, isImageType: false),
                        Card(name: "mie", icon: "mie", category: .NOUN, isImageType: false),
                        Card(name: "susu", icon: "susu", category: .NOUN, isImageType: false),
                        Card(name: "teh", icon: "teh", category: .NOUN, isImageType: false)
                    ]
                    
                ],
                name: "Ruang Makan",
                icon: "PIRING",
                gridSize: Grid(row: 5, column: 8 )
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isImageType: false),
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isImageType: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "menulis", icon: "menulis", category: .VERB, isImageType: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isImageType: false),
                        Card(name: "menggambar", icon: "menggambar", category: .VERB, isImageType: false),
                        Card(name: "mewarnai", icon: "mewarnai", category: .VERB, isImageType: false),
                        Card(name: "menggunting", icon: "menggunting", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "berat", icon: "berat", category: .ADJECTIVE, isImageType: false),
                        Card(name: "besar", icon: "besar", category: .ADJECTIVE, isImageType: false),
                        Card(name: "kecil", icon: "kecil", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false)

                    ],
                    [
                        Card(name: "kertas", icon: "kertas", category: .NOUN, isImageType: false),
                        Card(name: "buku", icon: "buku", category: .NOUN, isImageType: false),
                        Card(name: "pensil", icon: "pensil", category: .NOUN, isImageType: false),
                        Card(name: "rautan", icon: "rautan", category: .NOUN, isImageType: false),
                        Card(name: "crayon", icon: "crayon", category: .NOUN, isImageType: false)
                        
                    ],
                    [
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isImageType: false),
                        Card(name: "meja", icon: "meja", category: .NOUN, isImageType: false),
                        Card(name: "tong sampah", icon: "tong sampah", category: .NOUN, isImageType: false),
                        Card(name: "lem", icon: "lem", category: .NOUN, isImageType: false),
                        Card(name: "gunting", icon: "gunting", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "di dalam", icon: "di dalam", category: .CONJUNCTION, isImageType: false),
                        Card(name: "di luar", icon: "di luar", category: .CONJUNCTION, isImageType: false),
                        Card(name: "di atas", icon: "di atas", category: .CONJUNCTION, isImageType: false),
                        Card(name: "di bawah", icon: "di bawah", category: .CONJUNCTION, isImageType: false),
                        Card(name: "di samping", icon: "di samping", category: .CONJUNCTION, isImageType: false),
                    ]
                ],
                name: "Ruang Belajar",
                icon: "BUKU",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isImageType: false),
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isImageType: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "toilet", icon: "toilet", category: .VERB, isImageType: false),
                        Card(name: "mandi", icon: "mandi", category: .VERB, isImageType: false),
                        Card(name: "menyikat gigi", icon: "menyikat gigi", category: .VERB, isImageType: false),
                        Card(name: "cuci tangan", icon: "cuci tangan", category: .VERB, isImageType: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "keras", icon: "keras", category: .ADJECTIVE, isImageType: false),
                        Card(name: "berat", icon: "berat", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false)

                    ],
                    [
                        Card(name: "sampo", icon: "shampo", category: .NOUN, isImageType: false),
                        Card(name: "sabun", icon: "sabun", category: .NOUN, isImageType: false),
                        Card(name: "pasta gigi", icon: "pasta gigi", category: .NOUN, isImageType: false),
                        Card(name: "sikat gigi", icon: "sikat gigi", category: .NOUN, isImageType: false),
                        Card(name: "handuk", icon: "handuk", category: .NOUN, isImageType: false)
                        
                    ],
                    [
                        Card(name: "baju", icon: "baju", category: .NOUN, isImageType: false),
                        Card(name: "celana pendek", icon: "celana pendek", category: .NOUN, isImageType: false),
                        Card(name: "air", icon: "air", category: .NOUN, isImageType: false),
                        Card(name: "gelas", icon: "gelas", category: .NOUN, isImageType: false),
                        Card(name: "lemari", icon: "lemari", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "di", icon: "di", category: .CONJUNCTION, isImageType: false),
                        Card(name: "ke", icon: "ke", category: .CONJUNCTION, isImageType: false),
                        Card(name: "dan", icon: "dan", category: .CONJUNCTION, isImageType: false),
                    ]
                ],
                name: "Kamar Mandi",
                icon: "BAK MANDI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak mau", icon: "tidak mau", category: .SOCIAL, isImageType: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "tidur", icon: "kasur", category: .VERB, isImageType: false),
//                        Card(name: "mengantuk", icon: "mengantuk", category: .VERB, isImageType: false),
                        Card(name: "mendengar", icon: "mendengar", category: .VERB, isImageType: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isImageType: false),
//                        Card(name: "ganti baju", icon: "ganti baju", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "toilet", icon: "toilet", category: .VERB, isImageType: false),
                        Card(name: "mandi", icon: "mandi", category: .VERB, isImageType: false),
                        Card(name: "minum", icon: "minum", category: .VERB, isImageType: false),
                        Card(name: "sakit", icon: "sakit", category: .VERB, isImageType: false),
                        Card(name: "gatal", icon: "gatal", category: .VERB, isImageType: false),



                    ],
                    [
                        Card(name: "gelap", icon: "gelap", category: .ADJECTIVE, isImageType: false),
                        Card(name: "terang", icon: "terang", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false)

                    ],
                    [
                        Card(name: "tempat tidur", icon: "kasur", category: .NOUN, isImageType: false),
                        Card(name: "bantal", icon: "bantal", category: .NOUN, isImageType: false),
//                        Card(name: "guling", icon: "guling", category: .NOUN, isImageType: false),
//                        Card(name: "selimut", icon: "selimut", category: .NOUN, isImageType: false),
//                        Card(name: "buku cerita", icon: "buku cerita", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "meja", icon: "meja", category: .NOUN, isImageType: false),
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isImageType: false),
                        Card(name: "lampu", icon: "lampu", category: .NOUN, isImageType: false),
                        Card(name: "jam", icon: "jam", category: .NOUN, isImageType: false),
                        Card(name: "lemari", icon: "lemari", category: .NOUN, isImageType: false),
                    ]
                ],
                name: "Kamar Tidur",
                icon: "KASUR",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isImageType: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "cuci piring", icon: "cuci piring", category: .VERB, isImageType: false),
                        Card(name: "potong", icon: "memotong", category: .VERB, isImageType: false),
                        Card(name: "masak", icon: "wajan", category: .VERB, isImageType: false),
                        Card(name: "buka", icon: "buka", category: .VERB, isImageType: false),
                        Card(name: "tutup", icon: "tutup", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "masukkan", icon: "MASUK", category: .VERB, isImageType: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isImageType: false),
//                        Card(name: "aduk", icon: "aduk", category: .VERB, isImageType: false),
                        Card(name: "buang", icon: "buang", category: .VERB, isImageType: false),


                    ],
                    [
                        Card(name: "asin", icon: "asin", category: .ADJECTIVE, isImageType: false),
                        Card(name: "manis", icon: "manis", category: .ADJECTIVE, isImageType: false),
                        Card(name: "selesai", icon: "selesai", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false)

                    ],
                    [
//                        Card(name: "pisau", icon: "pisau", category: .NOUN, isImageType: false),
//                        Card(name: "talenan", icon: "talenan", category: .NOUN, isImageType: false),
                        Card(name: "keran", icon: "keran", category: .NOUN, isImageType: false),
                        Card(name: "kompor", icon: "kompor", category: .NOUN, isImageType: false),
                        Card(name: "panci", icon: "panci", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "sendok", icon: "sendok", category: .NOUN, isImageType: false),
                        Card(name: "garpu", icon: "garpu", category: .NOUN, isImageType: false),
                        Card(name: "piring", icon: "piring", category: .NOUN, isImageType: false)
                    ]
                ],
                name: "Dapur",
                icon: "PANCI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isImageType: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isImageType: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isImageType: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isImageType: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isImageType: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isImageType: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isImageType: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isImageType: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isImageType: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isImageType: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isImageType: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isImageType: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isImageType: false)
                    ],
                    [
                        Card(name: "makan", icon: "makan", category: .VERB, isImageType: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isImageType: false),
//                        Card(name: "menonton", icon: "menonton", category: .VERB, isImageType: false),
                        Card(name: "mendengar", icon: "mendengar", category: .VERB, isImageType: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isImageType: false)
                    ],
                    [
                        Card(name: "keras", icon: "keras", category: .ADJECTIVE, isImageType: false),
                        Card(name: "besar", icon: "besar", category: .ADJECTIVE, isImageType: false),
                        Card(name: "kecil", icon: "kecil", category: .ADJECTIVE, isImageType: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isImageType: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isImageType: false)

                    ],
                    [
                        Card(name: "televisi", icon: "televisi", category: .NOUN, isImageType: false),
                        Card(name: "meja", icon: "meja", category: .NOUN, isImageType: false),
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isImageType: false),
                        Card(name: "buku", icon: "buku", category: .NOUN, isImageType: false),
                        Card(name: "mainan", icon: "mainan", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "youtube", icon: "youtube", category: .NOUN, isImageType: false),
                        Card(name: "permainan", icon: "permainan", category: .NOUN, isImageType: false),
                        Card(name: "snack", icon: "piring", category: .NOUN, isImageType: false),
                        Card(name: "lampu", icon: "lampu", category: .NOUN, isImageType: false),
                        Card(name: "netflix", icon: "netflix", category: .NOUN, isImageType: false),
                    ],
                    [
                        Card(name: "mobil", icon: "mobil", category: .NOUN, isImageType: false),
                        Card(name: "bola", icon: "bola", category: .NOUN, isImageType: false),
                        Card(name: "air", icon: "gelas", category: .NOUN, isImageType: false),
                        Card(name: "snack", icon: "manis", category: .NOUN, isImageType: false)
                    ],
                ],
                name: "Ruang Keluarga",
                icon: "televisi",
                gridSize: Grid(row: 5, column: 8)
            )
        ]
        
        for data in datas {
            self.model.insert(data)
        }
        guard let _ = try? self.model.save() else {
            return
        }
    }
    
    func setBoards(_ boards: [Board]) {
        self.boards = boards
    }
    
    func selectId(_ id: UUID) {
        self.selectedID = id
    }
    
    func selectedName(for id: UUID) -> String? {
        if let board = boards.first(where: { $0.id == id }) {
            return board.name
        }
        return nil
    }

    
    //MARK: CRUD Board
    func addBoard(_ board: Board) {
        self.boards.append(board)
        self.model.insert(board)
        do {
            try self.model.save()
        } catch {
            print("SAVE ERROR")
        }
    }
    func removeBoard() {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: {$0.id == id} ) {
            if let board = self.boards[safe: index] {
                self.model.delete(board)
                do {
                    try self.model.save()
                } catch {
                    print("SAVE ERROR")
                }
            }
            self.boards.remove(at: index)
            
        }
    }
    
    //MARK: CRUD Card
    func addCard(_ card: Card, column: Int) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: {$0.id == id} ) {
            self.boards[index].cards[column].append(card)
            do {
                try self.model.save()
            } catch {
                print("SAVE ERROR")
            }
        }
    }
    
    func removeCard( column: Int, row: Int) {
        guard let id = self.selectedID else { return } // clausal guard in CPP
        if let index = self.boards.firstIndex(where: { $0.id == id } ) {
            self.boards[index].cards[column].remove(at: row)
            do {
                try self.model.save()
            } catch {
                print("SAVE ERROR")
            }
        }
    }
}
