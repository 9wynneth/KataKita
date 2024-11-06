import SwiftUI

struct BoardCreateView: View {
    @Binding var boardName: String
    @Binding var selectedIcon: String
    @Binding var gridSize: String
    @Binding var defaultButton: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var addingBoard = false
    @State private var totalgrid: Int = 20

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nama Board")) {
                    TextField("Masukkan nama board", text: $boardName)
                }
                
                Section(header: Text("Pilih Icon / Gambar")) {
                    VStack {
                        HStack {
                            Text("Icon yang dipilih: \(selectedIcon)")
                            Spacer()
                            NavigationLink("Pilih Icon") {
                                SearchIconView(selectedIcon: $selectedIcon)
                            }
                        }
                        if !selectedIcon.isEmpty {
                            CustomButton(
                                icon: resolveIcon(for: selectedIcon),
                                text: selectedIcon,
                                width: 100,
                                height: 100,
                                font: 20,
                                iconWidth: 50,
                                iconHeight: 50,
                                bgColor: "#FFFFFF",
                                bgTransparency: 1.0,
                                fontColor: "#000000",
                                fontTransparency: 1.0,
                                cornerRadius: 20,
                                isSystemImage: selectedIcon.contains("person.fill")
                            )
                        }
                    }
                }
                
                Section(header: Text("Pilih Ukuran Grid")) {
                    Picker("Ukuran Grid", selection: $gridSize) {
                        Text("4 x 5").tag("4 x 5")
                        Text("4 x 7").tag("4 x 7")
                        Text("5 x 8").tag("5 x 8")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: gridSize) { newValue in
                        switch newValue {
                        case "4 x 5":
                            totalgrid = 20
                        case "4 x 7":
                            totalgrid = 28
                        case "5 x 8":
                            totalgrid = 40
                        default:
                            totalgrid = 20
                        }
                    }
                }
            }
            .navigationBarTitle("Buat Board Baru", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Selesai") {
                    if !boardName.isEmpty {
                        let gridRows = totalgrid == 20 ? 5 : totalgrid == 28 ? 7 : 8
                        let gridColumns = totalgrid == 20 || totalgrid == 28 ? 4 : 5
                        
                        BoardManager.shared.addBoard(
                            Board(
                                cards: Array(repeating: [], count: gridRows),
                                name: boardName,
                                icon: selectedIcon,
                                gridSize: Grid(row: gridColumns, column: gridRows)
                            )
                        )
                        addingBoard = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

// MARK: - SearchIconView for Icon Selection
import SwiftUI

struct SearchIconView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    let allIcons = AllAssets.assets

    var filteredIcons: [String] {
        if searchText.isEmpty {
            return allIcons
        } else {
            return allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(filteredIcons, id: \.self) { icon in
                    Button(action: {
                        // Update selectedIcon and dismiss the view
                        selectedIcon = icon
                        dismiss()
                    }) {
                        CustomButton(
                            icon: resolveIcon(for: icon),
                            text: icon,
                            width: 200,
                            height: 200,
                            font: 40,
                            iconWidth: 100,
                            iconHeight: 100,
                            bgColor: "#FFFFFF",
                            bgTransparency: 1.0,
                            fontColor: "#000000",
                            fontTransparency: 1.0,
                            cornerRadius: 20,
                            isSystemImage: icon.contains("person.fill")) {
                                selectedIcon = icon
                                dismiss()
                            }
                    }
                }
            }
            .padding()
        }
        .searchable(text: $searchText)
        .navigationBarTitle("Cari Icon", displayMode: .inline)
    }
}
