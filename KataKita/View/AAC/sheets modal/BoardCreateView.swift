import SwiftUI

struct BoardCreateView: View {
    @Binding var boardName: String
    @Binding var selectedIcon: String
    @Binding var gridSize: String
    @Binding var defaultButton: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var addingBoard = false
    @State private var totalgrid: Int = 20
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(BoardManager.self) private var boardManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nama Board")) {
                    TextField("Masukkan nama board", text: $boardName)
                }
                
                Section(header: Text("Pilih Icon / Gambar")) {
                    VStack {
                        HStack {
                            Text("Icon yang dipilih: ")
                            Spacer()
                            NavigationLink("Pilih Icon") {
                                SearchIconView(selectedIcon: $selectedIcon)
                            }
                        }
                        if !selectedIcon.isEmpty {
                            CustomButtonBoard(
                                icon: selectedIcon,
                                text: getDisplayText(for: selectedIcon),
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
                        
                        // Check if the language is English before converting
                        if Locale.current.languageCode == "en" {
                            if selectedIcon.hasPrefix("GIRL_") {
                                selectedIcon = selectedIcon
                            }
                            else if selectedIcon.hasPrefix("BOY_") {
                                selectedIcon = selectedIcon

                            }
                            else {
                                selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                            }
                        }
                        
                        boardManager.addBoard(
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
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon
                } else {
                    return icon
                    
                }
            }
        }
        else {
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return icon.replacingOccurrences(of: "GIRL_", with: "")
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return icon.replacingOccurrences(of: "BOY_", with: "")
                } else {
                    return icon
                    
                }
            }
        }
        
    }
    
    // MARK: - SearchIconView for Icon Selection
    
    struct SearchIconView: View {
        @Binding var selectedIcon: String
        @Environment(\.dismiss) private var dismiss
        @State private var searchText = ""
        @StateObject private var viewModel = ProfileViewModel()
        
        // Select assets based on the device language (Indonesian or English)
        var allIcons: [String] {
            let locale = Locale.current.languageCode
            if viewModel.userProfile.gender == true {
                if locale == "id" {
                    return AllAssets.assets + AllAssets.girlAssets
                } else {
                    return AllAssets.englishAssets + AllAssets.girlAssets
                }
            }
            else {
                if locale == "id" {
                    return AllAssets.assets + AllAssets.boyAssets
                } else {
                    return AllAssets.englishAssets + AllAssets.boyAssets
                }
            }
        }
        
        var filteredIcons: [String] {
            if !searchText.isEmpty {
                if viewModel.userProfile.gender == true {
                    if let girlAsset = allIcons.filter({ $0.contains("GIRL_") }).first(where: { $0.localizedCaseInsensitiveContains("GIRL_" + searchText) }) {
                        return [girlAsset] + Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                    } else {
                        return Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                    }
                } else {
                    if let boyAsset = allIcons.filter({ $0.contains("BOY_") }).first(where: { $0.localizedCaseInsensitiveContains("BOY_" + searchText) }) {
                        return [boyAsset] + Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                    } else {
                        return Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                    }
                }
            } else {
                return allIcons
            }
        }
        
        var body: some View {
            VStack {
                TextField("Cari Icon", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                        ForEach(filteredIcons, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                                dismiss()
                            }) {
                                CustomButtonBoard(
                                    icon: icon,
                                    text: (getDisplayText(for: icon)),
                                    width: 150,
                                    height: 150,
                                    font: 40,
                                    iconWidth: 75,
                                    iconHeight: 75,
                                    bgColor: "#FFFFFF",
                                    bgTransparency: 1.0,
                                    fontColor: "#000000",
                                    fontTransparency: 1.0,
                                    cornerRadius: 20,
                                    isSystemImage: icon.contains("person.fill")) {
                                        selectedIcon = icon
                                        dismiss()
                                    }
                                    .onAppear {
                                        print("trial" + icon + getDisplayText(for: icon))
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            
            
            .navigationBarTitle("Cari Icon", displayMode: .inline)
        }
        
        private func getDisplayText(for icon: String) -> String {
            print(icon)
            if Locale.current.languageCode == "en" {
                let localizedIcon = NSLocalizedString(icon, comment: "")
                let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
                if viewModel.userProfile.gender == true {
                    if icon.hasPrefix("GIRL_") {
                        return localizedIcon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if icon.hasPrefix("BOY_") {
                        return localizedIcon
                    } else {
                        return icon
                        
                    }
                }
            }
            else {
                if viewModel.userProfile.gender == true {
                    if icon.hasPrefix("GIRL_") {
                        return icon.replacingOccurrences(of: "GIRL_", with: "")
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if icon.hasPrefix("BOY_") {
                        return icon.replacingOccurrences(of: "BOY_", with: "")
                    } else {
                        return icon
                        
                    }
                }
            }
            
        }
    }
}
