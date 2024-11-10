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
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak mau", icon: "tidak mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "makan", icon: "makan", category: .VERB, isIconTypeImage: false),
                        Card(name: "minum", icon: "minum", category: .VERB, isIconTypeImage: false),
                        Card(name: "putar", icon: "putar", category: .VERB, isIconTypeImage: false),
                        Card(name: "buka", icon: "buka", category: .VERB, isIconTypeImage: false),
                        Card(name: "tutup", icon: "tutup", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "ambil", icon: "ambil", category: .VERB, isIconTypeImage: false),
                        Card(name: "kunyah", icon: "mengunyah", category: .VERB, isIconTypeImage: false),
                        Card(name: "potong", icon: "memotong", category: .VERB, isIconTypeImage: false),
                        Card(name: "buang", icon: "buang", category: .VERB, isIconTypeImage: false),
                        Card(name: "masukkan", icon: "MASUK", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "asin", icon: "asin", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "manis", icon: "manis", category: .ADJECTIVE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "sendok", icon: "sendok", category: .NOUN, isIconTypeImage: false),
                        Card(name: "garpu", icon: "garpu", category: .NOUN, isIconTypeImage: false),
                        Card(name: "piring", icon: "piring", category: .NOUN, isIconTypeImage: false),
                        Card(name: "mangkok", icon: "sup", category: .NOUN, isIconTypeImage: false),
                        Card(name: "gelas", icon: "gelas", category: .NOUN, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "ayam goreng", icon: "ayam goreng", category: .NOUN, isIconTypeImage: false),
                        Card(name: "nasi", icon: "nasi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "mie", icon: "mie", category: .NOUN, isIconTypeImage: false),
                        Card(name: "susu", icon: "susu", category: .NOUN, isIconTypeImage: false),
                        Card(name: "teh", icon: "teh", category: .NOUN, isIconTypeImage: false)
                    ]
                    
                ],
                name: "Ruang Makan",
                icon: "PIRING",
                gridSize: Grid(row: 5, column: 8 )
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "menulis", icon: "menulis", category: .VERB, isIconTypeImage: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isIconTypeImage: false),
                        Card(name: "menggambar", icon: "menggambar", category: .VERB, isIconTypeImage: false),
                        Card(name: "mewarnai", icon: "mewarnai", category: .VERB, isIconTypeImage: false),
                        Card(name: "menggunting", icon: "menggunting", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "berat", icon: "berat", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "besar", icon: "besar", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "kecil", icon: "kecil", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false)

                    ],
                    [
                        Card(name: "kertas", icon: "kertas", category: .NOUN, isIconTypeImage: false),
                        Card(name: "buku", icon: "buku", category: .NOUN, isIconTypeImage: false),
                        Card(name: "pensil", icon: "pensil", category: .NOUN, isIconTypeImage: false),
                        Card(name: "rautan", icon: "rautan", category: .NOUN, isIconTypeImage: false),
                        Card(name: "crayon", icon: "crayon", category: .NOUN, isIconTypeImage: false)
                        
                    ],
                    [
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "meja", icon: "meja", category: .NOUN, isIconTypeImage: false),
                        Card(name: "tong sampah", icon: "tong sampah", category: .NOUN, isIconTypeImage: false),
                        Card(name: "lem", icon: "lem", category: .NOUN, isIconTypeImage: false),
                        Card(name: "gunting", icon: "gunting", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "di dalam", icon: "di dalam", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "di luar", icon: "di luar", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "di atas", icon: "di atas", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "di bawah", icon: "di bawah", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "di samping", icon: "di samping", category: .CONJUNCTION, isIconTypeImage: false),
                    ]
                ],
                name: "Ruang Belajar",
                icon: "BUKU",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "toilet", icon: "toilet", category: .VERB, isIconTypeImage: false),
                        Card(name: "mandi", icon: "mandi", category: .VERB, isIconTypeImage: false),
                        Card(name: "menyikat gigi", icon: "menyikat gigi", category: .VERB, isIconTypeImage: false),
                        Card(name: "cuci tangan", icon: "cuci tangan", category: .VERB, isIconTypeImage: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "keras", icon: "keras", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "berat", icon: "berat", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false)

                    ],
                    [
                        Card(name: "sampo", icon: "shampo", category: .NOUN, isIconTypeImage: false),
                        Card(name: "sabun", icon: "sabun", category: .NOUN, isIconTypeImage: false),
                        Card(name: "pasta gigi", icon: "pasta gigi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "sikat gigi", icon: "sikat gigi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "handuk", icon: "handuk", category: .NOUN, isIconTypeImage: false)
                        
                    ],
                    [
                        Card(name: "baju", icon: "baju", category: .NOUN, isIconTypeImage: false),
                        Card(name: "celana pendek", icon: "celana pendek", category: .NOUN, isIconTypeImage: false),
                        Card(name: "air", icon: "air", category: .NOUN, isIconTypeImage: false),
                        Card(name: "gelas", icon: "gelas", category: .NOUN, isIconTypeImage: false),
                        Card(name: "lemari", icon: "lemari", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "di", icon: "di", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "ke", icon: "ke", category: .CONJUNCTION, isIconTypeImage: false),
                        Card(name: "dan", icon: "dan", category: .CONJUNCTION, isIconTypeImage: false),
                    ]
                ],
                name: "Kamar Mandi",
                icon: "BAK MANDI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "mau", icon: "mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak mau", icon: "tidak mau", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "tidur", icon: "kasur", category: .VERB, isIconTypeImage: false),
                        Card(name: "mengantuk", icon: "mengantuk", category: .VERB, isIconTypeImage: false),
                        Card(name: "mendengar", icon: "mendengar", category: .VERB, isIconTypeImage: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isIconTypeImage: false),
                        Card(name: "ganti baju", icon: "ganti baju", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "toilet", icon: "toilet", category: .VERB, isIconTypeImage: false),
                        Card(name: "mandi", icon: "mandi", category: .VERB, isIconTypeImage: false),
                        Card(name: "minum", icon: "minum", category: .VERB, isIconTypeImage: false),
                        Card(name: "sakit", icon: "sakit", category: .VERB, isIconTypeImage: false),
                        Card(name: "gatal", icon: "gatal", category: .VERB, isIconTypeImage: false),



                    ],
                    [
                        Card(name: "gelap", icon: "gelap", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "terang", icon: "terang", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false)

                    ],
                    [
                        Card(name: "tempat tidur", icon: "kasur", category: .NOUN, isIconTypeImage: false),
                        Card(name: "bantal", icon: "bantal", category: .NOUN, isIconTypeImage: false),
                        Card(name: "guling", icon: "guling", category: .NOUN, isIconTypeImage: false),
                        Card(name: "selimut", icon: "selimut", category: .NOUN, isIconTypeImage: false),
                        Card(name: "buku cerita", icon: "buku cerita", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "meja", icon: "meja", category: .NOUN, isIconTypeImage: false),
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "lampu", icon: "lampu", category: .NOUN, isIconTypeImage: false),
                        Card(name: "jam", icon: "jam", category: .NOUN, isIconTypeImage: false),
                        Card(name: "lemari", icon: "lemari", category: .NOUN, isIconTypeImage: false),
                    ]
                ],
                name: "Kamar Tidur",
                icon: "KASUR",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "cuci piring", icon: "cuci piring", category: .VERB, isIconTypeImage: false),
                        Card(name: "potong", icon: "memotong", category: .VERB, isIconTypeImage: false),
                        Card(name: "masak", icon: "wajan", category: .VERB, isIconTypeImage: false),
                        Card(name: "buka", icon: "buka", category: .VERB, isIconTypeImage: false),
                        Card(name: "tutup", icon: "tutup", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "masukkan", icon: "MASUK", category: .VERB, isIconTypeImage: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isIconTypeImage: false),
                        Card(name: "aduk", icon: "aduk", category: .VERB, isIconTypeImage: false),
                        Card(name: "buang", icon: "buang", category: .VERB, isIconTypeImage: false),


                    ],
                    [
                        Card(name: "asin", icon: "asin", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "manis", icon: "manis", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "selesai", icon: "selesai", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false)

                    ],
                    [
                        Card(name: "pisau", icon: "pisau", category: .NOUN, isIconTypeImage: false),
                        Card(name: "talenan", icon: "talenan", category: .NOUN, isIconTypeImage: false),
                        Card(name: "keran", icon: "keran", category: .NOUN, isIconTypeImage: false),
                        Card(name: "kompor", icon: "kompor", category: .NOUN, isIconTypeImage: false),
                        Card(name: "panci", icon: "panci", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "sendok", icon: "sendok", category: .NOUN, isIconTypeImage: false),
                        Card(name: "garpu", icon: "garpu", category: .NOUN, isIconTypeImage: false),
                        Card(name: "piring", icon: "piring", category: .NOUN, isIconTypeImage: false)
                    ]
                ],
                name: "Dapur",
                icon: "PANCI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", icon: "saya", category: .CORE, isIconTypeImage: false),
                        Card(name: "kamu", icon: "kamu", category: .CORE, isIconTypeImage: false),
                        Card(name: "dia", icon: "dia", category: .CORE, isIconTypeImage: false),
                        Card(name: "kita", icon: "kita", category: .CORE, isIconTypeImage: false),
                        Card(name: "ibu", icon: "ibu", category: .CORE, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "apa", icon: "apa", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "dimana", icon: "dimana", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "kapan", icon: "kapan", category: .QUESTION, isIconTypeImage: false),
                        Card(name: "siapa", icon: "siapa", category: .QUESTION, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "suka", icon: "suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak suka", icon: "tidak suka", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "iya", icon: "iya", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tidak", icon: "tidak", category: .SOCIAL, isIconTypeImage: false),
                        Card(name: "tolong", icon: "tolong", category: .SOCIAL, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "makan", icon: "makan", category: .VERB, isIconTypeImage: false),
                        Card(name: "membaca", icon: "membaca", category: .VERB, isIconTypeImage: false),
                        Card(name: "menonton", icon: "menonton", category: .VERB, isIconTypeImage: false),
                        Card(name: "mendengar", icon: "mendengar", category: .VERB, isIconTypeImage: false),
                        Card(name: "ambil", icon: "ambil", category: .VERB, isIconTypeImage: false)
                    ],
                    [
                        Card(name: "keras", icon: "keras", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "besar", icon: "besar", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "kecil", icon: "kecil", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "panas", icon: "panas", category: .ADJECTIVE, isIconTypeImage: false),
                        Card(name: "dingin", icon: "dingin", category: .ADJECTIVE, isIconTypeImage: false)

                    ],
                    [
                        Card(name: "televisi", icon: "televisi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "meja", icon: "meja", category: .NOUN, isIconTypeImage: false),
                        Card(name: "kursi", icon: "kursi", category: .NOUN, isIconTypeImage: false),
                        Card(name: "buku", icon: "buku", category: .NOUN, isIconTypeImage: false),
                        Card(name: "mainan", icon: "mainan", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "youtube", icon: "youtube", category: .NOUN, isIconTypeImage: false),
                        Card(name: "permainan", icon: "permainan", category: .NOUN, isIconTypeImage: false),
                        Card(name: "snack", icon: "piring", category: .NOUN, isIconTypeImage: false),
                        Card(name: "lampu", icon: "lampu", category: .NOUN, isIconTypeImage: false),
                        Card(name: "netflix", icon: "netflix", category: .NOUN, isIconTypeImage: false),
                    ],
                    [
                        Card(name: "mobil", icon: "mobil", category: .NOUN, isIconTypeImage: false),
                        Card(name: "bola", icon: "bola", category: .NOUN, isIconTypeImage: false),
                        Card(name: "air", icon: "gelas", category: .NOUN, isIconTypeImage: false),
                        Card(name: "snack", icon: "manis", category: .NOUN, isIconTypeImage: false)
                    ],
                ],
                name: "Ruang Keluarga",
                icon: "TELEVISI",
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
