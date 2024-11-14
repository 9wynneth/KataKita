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
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "suka", category: .SOCIAL, type: .icon("suka")),
                        Card(name: "tidak suka", category: .SOCIAL, type: .icon("tidak suka")),
                        Card(name: "mau", category: .SOCIAL, type: .icon("mau")),
                        Card(name: "tidak mau", category: .SOCIAL, type: .icon("tidak mau")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "makan", category: .VERB, type: .icon("makan")),
                        Card(name: "minum", category: .VERB, type: .icon("minum")),
                        Card(name: "putar", category: .VERB, type: .icon("putar")),
                        Card(name: "buka", category: .VERB, type: .icon("buka")),
                        Card(name: "tutup", category: .VERB, type: .icon("tutup"))
                    ],
                    [
                        Card(name: "ambil", category: .VERB, type: .icon("ambil")),
                        Card(name: "kunyah", category: .VERB, type: .icon("mengunyah")),
                        Card(name: "potong", category: .VERB, type: .icon("memotong")),
                        Card(name: "buang", category: .VERB, type: .icon("buang")),
                        Card(name: "masukkan", category: .VERB, type: .icon("MASUK"))
                    ],
                    [
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "asin", category: .ADJECTIVE, type: .icon("asin")),
                        Card(name: "manis", category: .ADJECTIVE, type: .icon("manis"))
                    ],
                    [
                        Card(name: "sendok", category: .NOUN, type: .icon("sendok")),
                        Card(name: "garpu", category: .NOUN, type: .icon("garpu")),
                        Card(name: "piring", category: .NOUN, type: .icon("piring")),
                        Card(name: "mangkok", category: .NOUN, type: .icon("sup")),
                        Card(name: "air", category: .NOUN, type: .icon("gelas"))
                    ],
                    [
                        Card(name: "ayam goreng", category: .NOUN, type: .icon("ayam goreng")),
                        Card(name: "nasi", category: .NOUN, type: .icon("nasi")),
                        Card(name: "mie", category: .NOUN, type: .icon("mie")),
                        Card(name: "susu", category: .NOUN, type: .icon("susu")),
                        Card(name: "teh", category: .NOUN, type: .icon("teh"))
                    ]
                    
                ],
                name: "Ruang Makan",
                icon: "PIRING",
                gridSize: Grid(row: 5, column: 8 )
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "mau", category: .SOCIAL, type: .icon("mau")),
                        Card(name: "suka", category: .SOCIAL, type: .icon("suka")),
                        Card(name: "iya", category: .SOCIAL, type: .icon("iya")),
                        Card(name: "tidak", category: .SOCIAL, type: .icon("tidak")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "menulis", category: .VERB, type: .icon("menulis")),
                        Card(name: "membaca", category: .VERB, type: .icon("membaca")),
                        Card(name: "menggambar", category: .VERB, type: .icon("menggambar")),
                        Card(name: "mewarnai", category: .VERB, type: .icon("mewarnai")),
                        Card(name: "menggunting", category: .VERB, type: .icon("menggunting"))
                    ],
                    [
                        Card(name: "berat", category: .ADJECTIVE, type: .icon("berat")),
                        Card(name: "besar", category: .ADJECTIVE, type: .icon("besar")),
                        Card(name: "kecil", category: .ADJECTIVE, type: .icon("kecil")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin"))

                    ],
                    [
                        Card(name: "kertas", category: .NOUN, type: .icon("kertas")),
                        Card(name: "buku", category: .NOUN, type: .icon("buku")),
                        Card(name: "pensil", category: .NOUN, type: .icon("pensil")),
                        Card(name: "rautan", category: .NOUN, type: .icon("rautan")),
                        Card(name: "crayon", category: .NOUN, type: .icon("crayon"))
                        
                    ],
                    [
                        Card(name: "kursi", category: .NOUN, type: .icon("kursi")),
                        Card(name: "meja", category: .NOUN, type: .icon("meja")),
                        Card(name: "tong sampah", category: .NOUN, type: .icon("tong sampah")),
                        Card(name: "lem", category: .NOUN, type: .icon("lem")),
                        Card(name: "gunting", category: .NOUN, type: .icon("gunting")),
                    ],
                    [
                        Card(name: "di dalam", category: .CONJUNCTION, type: .icon("di dalam")),
                        Card(name: "di luar", category: .CONJUNCTION, type: .icon("di luar")),
                        Card(name: "di atas", category: .CONJUNCTION, type: .icon("di atas")),
                        Card(name: "di bawah", category: .CONJUNCTION, type: .icon("di bawah")),
                        Card(name: "di samping", category: .CONJUNCTION, type: .icon("di samping")),
                    ]
                ],
                name: "Ruang Belajar",
                icon: "BUKU",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "mau", category: .SOCIAL, type: .icon("mau")),
                        Card(name: "suka", category: .SOCIAL, type: .icon("suka")),
                        Card(name: "iya", category: .SOCIAL, type: .icon("iya")),
                        Card(name: "tidak", category: .SOCIAL, type: .icon("tidak")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "toilet", category: .VERB, type: .icon("toilet")),
                        Card(name: "mandi", category: .VERB, type: .icon("mandi")),
                        Card(name: "menyikat gigi", category: .VERB, type: .icon("menyikat gigi")),
                        Card(name: "cuci tangan", category: .VERB, type: .icon("cuci tangan")),
                        Card(name: "ambil", category: .VERB, type: .icon("ambil"))
                    ],
                    [
                        Card(name: "keras", category: .ADJECTIVE, type: .icon("keras")),
                        Card(name: "berat", category: .ADJECTIVE, type: .icon("berat")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin"))

                    ],
                    [
                        Card(name: "sampo", category: .NOUN, type: .icon("shampo")),
                        Card(name: "sabun", category: .NOUN, type: .icon("sabun")),
                        Card(name: "pasta gigi", category: .NOUN, type: .icon("pasta gigi")),
                        Card(name: "sikat gigi", category: .NOUN, type: .icon("sikat gigi")),
                        Card(name: "handuk", category: .NOUN, type: .icon("handuk"))
                        
                    ],
                    [
                        Card(name: "baju", category: .NOUN, type: .icon("baju")),
                        Card(name: "celana", category: .NOUN, type: .icon("celana pendek")),
                        Card(name: "air", category: .NOUN, type: .icon("air")),
                        Card(name: "gelas", category: .NOUN, type: .icon("gelas")),
                        Card(name: "lemari", category: .NOUN, type: .icon("lemari")),
                    ],
                    [
                        Card(name: "di", category: .CONJUNCTION, type: .icon("di")),
                        Card(name: "ke", category: .CONJUNCTION, type: .icon("ke")),
                        Card(name: "dan", category: .CONJUNCTION, type: .icon("dan")),
                    ]
                ],
                name: "Kamar Mandi",
                icon: "BAK MANDI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "mau", category: .SOCIAL, type: .icon("mau")),
                        Card(name: "tidak mau", category: .SOCIAL, type: .icon("tidak mau")),
                        Card(name: "iya", category: .SOCIAL, type: .icon("iya")),
                        Card(name: "tidak", category: .SOCIAL, type: .icon("tidak")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "tidur", category: .VERB, type: .icon("kasur")),
    //                        Card(name: "mengantuk", category: .VERB, type: .icon("mengantuk")),
                        Card(name: "mendengar", category: .VERB, type: .icon("mendengar")),
                        Card(name: "membaca", category: .VERB, type: .icon("membaca")),
    //                        Card(name: "ganti baju", category: .VERB, type: .icon("ganti baju"))
                    ],
                    [
                        Card(name: "toilet", category: .VERB, type: .icon("toilet")),
                        Card(name: "mandi", category: .VERB, type: .icon("mandi")),
                        Card(name: "minum", category: .VERB, type: .icon("minum")),
                        Card(name: "sakit", category: .VERB, type: .icon("sakit")),
                        Card(name: "gatal", category: .VERB, type: .icon("gatal")),



                    ],
                    [
                        Card(name: "gelap", category: .ADJECTIVE, type: .icon("gelap")),
                        Card(name: "terang", category: .ADJECTIVE, type: .icon("terang")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin"))

                    ],
                    [
                        Card(name: "tempat tidur", category: .NOUN, type: .icon("kasur")),
                        Card(name: "bantal", category: .NOUN, type: .icon("bantal")),
    //                        Card(name: "guling", category: .NOUN, type: .icon("guling")),
    //                        Card(name: "selimut", category: .NOUN, type: .icon("selimut")),
    //                        Card(name: "buku cerita", category: .NOUN, type: .icon("buku cerita")),
                    ],
                    [
                        Card(name: "meja", category: .NOUN, type: .icon("meja")),
                        Card(name: "kursi", category: .NOUN, type: .icon("kursi")),
                        Card(name: "lampu", category: .NOUN, type: .icon("lampu")),
                        Card(name: "jam", category: .NOUN, type: .icon("jam")),
                        Card(name: "lemari", category: .NOUN, type: .icon("lemari")),
                    ]
                ],
                name: "Kamar Tidur",
                icon: "KASUR",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "suka", category: .SOCIAL, type: .icon("suka")),
                        Card(name: "tidak suka", category: .SOCIAL, type: .icon("tidak suka")),
                        Card(name: "iya", category: .SOCIAL, type: .icon("iya")),
                        Card(name: "tidak", category: .SOCIAL, type: .icon("tidak")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "cuci piring", category: .VERB, type: .icon("cuci piring")),
                        Card(name: "potong", category: .VERB, type: .icon("memotong")),
                        Card(name: "masak", category: .VERB, type: .icon("wajan")),
                        Card(name: "buka", category: .VERB, type: .icon("buka")),
                        Card(name: "tutup", category: .VERB, type: .icon("tutup"))
                    ],
                    [
                        Card(name: "masukkan", category: .VERB, type: .icon("MASUK")),
                        Card(name: "ambil", category: .VERB, type: .icon("ambil")),
    //                        Card(name: "aduk", category: .VERB, type: .icon("aduk")),
                        Card(name: "buang", category: .VERB, type: .icon("buang")),


                    ],
                    [
                        Card(name: "asin", category: .ADJECTIVE, type: .icon("asin")),
                        Card(name: "manis", category: .ADJECTIVE, type: .icon("manis")),
                        Card(name: "selesai", category: .ADJECTIVE, type: .icon("selesai")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin"))

                    ],
                    [
    //                        Card(name: "pisau", category: .NOUN, type: .icon("pisau")),
    //                        Card(name: "talenan", category: .NOUN, type: .icon("talenan")),
                        Card(name: "keran", category: .NOUN, type: .icon("keran")),
                        Card(name: "kompor", category: .NOUN, type: .icon("kompor")),
                        Card(name: "panci", category: .NOUN, type: .icon("panci")),
                    ],
                    [
                        Card(name: "sendok", category: .NOUN, type: .icon("sendok")),
                        Card(name: "garpu", category: .NOUN, type: .icon("garpu")),
                        Card(name: "piring", category: .NOUN, type: .icon("piring"))
                    ]
                ],
                name: "Dapur",
                icon: "PANCI",
                gridSize: Grid(row: 5, column: 8)
            ),
            Board(
                cards: [
                    [
                        Card(name: "saya", category: .CORE, type: .icon("saya")),
                        Card(name: "kamu", category: .CORE, type: .icon("kamu")),
                        Card(name: "dia", category: .CORE, type: .icon("dia")),
                        Card(name: "kita", category: .CORE, type: .icon("kita")),
                        Card(name: "ibu", category: .CORE, type: .icon("ibu"))
                    ],
                    [
                        Card(name: "apa", category: .QUESTION, type: .icon("apa")),
                        Card(name: "dimana", category: .QUESTION, type: .icon("dimana")),
                        Card(name: "kapan", category: .QUESTION, type: .icon("kapan")),
                        Card(name: "siapa", category: .QUESTION, type: .icon("siapa")),
                    ],
                    [
                        Card(name: "suka", category: .SOCIAL, type: .icon("suka")),
                        Card(name: "tidak suka", category: .SOCIAL, type: .icon("tidak suka")),
                        Card(name: "iya", category: .SOCIAL, type: .icon("iya")),
                        Card(name: "tidak", category: .SOCIAL, type: .icon("tidak")),
                        Card(name: "tolong", category: .SOCIAL, type: .icon("tolong"))
                    ],
                    [
                        Card(name: "makan", category: .VERB, type: .icon("makan")),
                        Card(name: "membaca", category: .VERB, type: .icon("membaca")),
    //                        Card(name: "menonton", category: .VERB, type: .icon("menonton")),
                        Card(name: "mendengar", category: .VERB, type: .icon("mendengar")),
                        Card(name: "ambil", category: .VERB, type: .icon("ambil"))
                    ],
                    [
                        Card(name: "keras", category: .ADJECTIVE, type: .icon("keras")),
                        Card(name: "besar", category: .ADJECTIVE, type: .icon("besar")),
                        Card(name: "kecil", category: .ADJECTIVE, type: .icon("kecil")),
                        Card(name: "panas", category: .ADJECTIVE, type: .icon("panas")),
                        Card(name: "dingin", category: .ADJECTIVE, type: .icon("dingin"))

                    ],
                    [
                        Card(name: "televisi", category: .NOUN, type: .icon("televisi")),
                        Card(name: "meja", category: .NOUN, type: .icon("meja")),
                        Card(name: "kursi", category: .NOUN, type: .icon("kursi")),
                        Card(name: "buku", category: .NOUN, type: .icon("buku")),
                        Card(name: "mainan", category: .NOUN, type: .icon("mainan")),
                    ],
                    [
                        Card(name: "youtube", category: .NOUN, type: .icon("youtube")),
                        Card(name: "permainan", category: .NOUN, type: .icon("permainan")),
                        Card(name: "snack", category: .NOUN, type: .icon("piring")),
                        Card(name: "lampu", category: .NOUN, type: .icon("lampu")),
                        Card(name: "netflix", category: .NOUN, type: .icon("netflix")),
                    ],
                    [
                        Card(name: "mobil", category: .NOUN, type: .icon("mobil")),
                        Card(name: "bola", category: .NOUN, type: .icon("bola")),
                        Card(name: "air", category: .NOUN, type: .icon("gelas")),
                        Card(name: "snack", category: .NOUN, type: .icon("manis"))
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
    
    func updateCard(column: Int, row: Int, updatedCard: Card) {
        guard let id = self.selectedID else { return } // Ensure there's a selected board
        if let boardIndex = self.boards.firstIndex(where: { $0.id == id }) {
            // Check if the specified column and row are within bounds
            guard column >= 0 && column < self.boards[boardIndex].cards.count,
                  row >= 0 && row < self.boards[boardIndex].cards[column].count else {
                print("UPDATE ERROR: Invalid column or row index")
                return
            }
            
            // Update the card at the specified column and row
            self.boards[boardIndex].cards[column][row] = updatedCard
            
            // Save changes to the model
            do {
                try self.model.save()
            } catch {
                print("SAVE ERROR: Unable to save updated card")
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
