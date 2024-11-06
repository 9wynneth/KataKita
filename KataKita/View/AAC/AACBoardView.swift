//
//  AACBoardView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 31/10/24.
//
import SwiftUI

struct AACBoardView : View {
    @Binding var editing: Bool
    @Binding var cards: [[Card]]?
    
    @State private var imageFromLocal: URL?
    let board: Board
    let spacing: CGFloat
    let add: ((Int) -> Void)?
    let del: ((Int, Int) -> Void)?
    
    var cellWidth: CGFloat {
        let size = CGFloat(board.gridSize.column)
        return (self.width - self.spacing * (size - 1)) / size
    }
    var cellHeight: CGFloat {
        let size = CGFloat(board.gridSize.row)
        return (self.height - self.spacing * (size - 1)) / size
    }
    
    @State private var width: CGFloat = 0.0
    @State private var height: CGFloat = 0.0
    
    init(
        _ board: Board,
        spacing: CGFloat = 10,
        editing: Binding<Bool> = Binding.constant(false),
        cards: Binding<[[Card]]?> = Binding.constant(nil),
        add: ((Int) -> Void)? = nil,
        del: ((Int, Int) -> Void)? = nil
    ) {
        self.board = board
        self.spacing = spacing
        self._cards = cards
        self._editing = editing
        self.add = add
        self.del = del
    }
    
    //MARK: Viewport Size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        HStack(alignment: .top, spacing: self.spacing) {
            ForEach(Array(board.cards.enumerated()), id: \.offset) { colIndex, column in
                if self.editing && column.isEmpty {
                    CustomButton(
                        icon: "plus",
                        text: "",
                        width: cellWidth,
                        height: cellHeight,
                        font: 24,
                        iconWidth: 80,
                        iconHeight: 60,
                        bgColor: "efefef",
                        bgTransparency: 0.65,
                        fontColor: "000000",
                        fontTransparency: 1.0,
                        cornerRadius: 13,
                        isSystemImage: true
                    ) {
                        if let add = self.add {
                            add(colIndex)
                        }
                    }
                } else if !column.isEmpty {
                    VStack (spacing: self.spacing){
                        ForEach(Array(column.enumerated()), id: \.offset) { rowIndex, row in
                            ZStack(alignment: .topTrailing) {
                                if row.isIconTypeImage == true {
                                    CustomIcon(
                                        icon: row.icon,
                                        text: row.name,
                                        width: cellWidth,
                                        height: cellHeight,
                                        font: 24,
                                        iconWidth: 80,
                                        iconHeight: 60,
                                        bgColor: Color(hex: row.category.getColorString(), transparency: 1),
                                        bgTransparency: 0.65,
                                        fontColor: Color.black,
                                        fontTransparency: 1.0,
                                        cornerRadius: 13
                                    )
                                } else {
                                    CustomButton(
                                        icon: resolveIcon(for: row.icon),
                                        text: row.name,
                                        width: cellWidth,
                                        height: cellHeight,
                                        font: 24,
                                        iconWidth: 80,
                                        iconHeight: 60,
                                        bgColor: row.category.getColorString(),
                                        bgTransparency: 0.65,
                                        fontColor: "000000",
                                        fontTransparency: 1.0, cornerRadius: 13, isSystemImage: false
                                    ) {
                                        if self.cards != nil {
                                            self.addCard(row)
                                        }
                                    }
                                }
                                if self.editing {
                                    CustomButton(
                                        icon: "xmark",
                                        text: "",
                                        width: 50,
                                        height: 50,
                                        font: 24,
                                        iconWidth: 20,
                                        iconHeight: 20,
                                        bgColor: "F47455",
                                        bgTransparency: 1,
                                        fontColor: "ffffff",
                                        fontTransparency: 1.0,
                                        cornerRadius: 25,
                                        isSystemImage: true
                                    ) {
                                        if let del = self.del {
                                            del(colIndex, rowIndex)
                                        }
                                    }
                                    .offset(x: -5, y: 5)
                                }
                            }
                        }
                        if self.editing && column.count < self.board.gridSize.row {
                            CustomButton(
                                icon: "plus",
                                text: "",
                                width: cellWidth,
                                height: cellHeight,
                                font: 24,
                                iconWidth: 80,
                                iconHeight: 60,
                                bgColor: "efefef",
                                bgTransparency: 0.65,
                                fontColor: "000000",
                                fontTransparency: 1.0,
                                cornerRadius: 13,
                                isSystemImage: true
                            ) {
                                if let add = self.add {
                                    add(colIndex)
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            GeometryReader{ geometry in
                Color.clear
                    .onAppear {
                        self.height = geometry.frame(in: .global).height
                        self.width = geometry.frame(in: .global).width
                        
                        print(self.height, self.width)
                        print(self.screenHeight, self.screenWidth)
                    }
            }
        )
    }
    
    private func addCard(_ card: Card) {
        if var cards = self.cards {
            if card.category == .CORE {
                cards[0].append(card)
            } else if let index = cards.firstIndex(where: { $0.contains(where: { $0.category == card.category }) }) {
                cards[index].append(card)
            } else if let index = cards.firstIndex(where: { $0.isEmpty }) {
                cards[index].append(card)
            }
            print("JANCOKOKO")
            self.cards = cards
        }
    }

}

#Preview {
    AACBoardView(
        Board(
            cards: [
                [
                    Card(name: "Aku", icon: "ASTRONOT", category: .CORE, isIconTypeImage: false),
                    Card(name: "Kamu", icon: "ASTRONOT", category: .CORE, isIconTypeImage: false),
                    Card(name: "Kita", icon: "ASTRONOT", category: .CORE, isIconTypeImage: false),
                    Card(name: "Mereka", icon: "ASTRONOT", category: .CORE, isIconTypeImage: false),
                    Card(name: "Ayah", icon: "ASTRONOT", category: .CORE, isIconTypeImage: false)
                ],
                [
                    Card(name: "Di atas", icon: "ASTRONOT", category: .SOCIAL, isIconTypeImage: false),
                    Card(name: "Terima kasih", icon: "ASTRONOT", category: .SOCIAL, isIconTypeImage: false),
                    Card(name: "Tidak", icon: "ASTRONOT", category: .SOCIAL, isIconTypeImage: false),
                    Card(name: "Suka", icon: "ASTRONOT", category: .SOCIAL, isIconTypeImage: false),
                ],
                [
                    Card(name: "Siapa", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                    Card(name: "Kapan", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                    Card(name: "Kenapa", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                ],
                [
                    Card(name: "Apa", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false)
                ],
                [
                    Card(name: "Apa", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                    Card(name: "Kapan", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                    Card(name: "Kenapa", icon: "ASTRONOT", category: .QUESTION, isIconTypeImage: false),
                ],
                [],
                [],
                []
            ],
            name: "Ruang Nentod",
            icon: "ASTRONOT",
            gridSize: Grid(row: 5, column: 8)
        ),
        spacing: 5,
        editing: Binding.constant(true)
    )
}
