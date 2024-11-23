import SwiftUI

struct BoardCreateView: View {
    @Binding var boardName: String
    @Binding var selectedIcon: String
    @Binding var gridSize: String
    @Binding var defaultButton: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var addingBoard = false
    @State private var totalgrid: Int = 20
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(BoardManager.self) private var boardManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
                   
                    
                    VStack(spacing: 16) {
                        // Nama Board Section
                        VStack(alignment: .leading, spacing: 4) {
                            TextContent(
                                text: "NAMA BOARD", size: 15, color: "FFFFFF", transparency: 1.0,
                                weight: "regular")
                            TextField("Masukkan nama board", text: $boardName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                        }
                        
                        // Pilih Icon / Gambar Section
                        VStack(alignment: .leading, spacing: 4) {
                            TextContent(
                                text: "PILIH ICON / GAMBAR", size: 15, color: "FFFFFF", transparency: 1.0,
                                weight: "regular")
                            NavigationLink(destination: SearchIconView(selectedIcon: $selectedIcon)) {
                                HStack {
                                    Text(LocalizedStringKey("Icon yang dipilih :"))
                                        .foregroundColor(.black)
                                    Spacer()
                                    NavigationLink(destination: SearchIconView(selectedIcon: $selectedIcon)) {
                                        Image(systemName: "chevron.right") // Replacing text with an arrow icon
                                            .foregroundColor(.black)
                                    }
                                    .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                            }
                            .foregroundColor(.black)
                            
                            
                            // Display selected icon if available
                            if !selectedIcon.isEmpty {
                                HStack{
                                    Spacer()
                                    CustomButtonBoard(
                                        icon: getDisplayIcon(for: selectedIcon),
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
                                    .padding(.top, 8)
                                    Spacer()
                                }
                            }
                        }
                        
                        // Pilih Ukuran Grid Section
                        VStack(alignment: .leading, spacing: 4) {
                            TextContent(
                                text: "PILIH UKURAN GRID", size: 15, color: "FFFFFF", transparency: 1.0,
                                weight: "regular")
                            Picker("Ukuran Grid", selection: $gridSize) {
                                Text("4 x 5").tag("4 x 5")
                                Text("4 x 7").tag("4 x 7")
                                Text("5 x 8").tag("5 x 8")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .onChange(of: gridSize) {
                                switch gridSize {
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
                        Spacer()
                        
                        CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                            if !boardName.isEmpty {
                                let gridRows = totalgrid == 20 ? 5 : totalgrid == 28 ? 7 : 8
                                let gridColumns = totalgrid == 20 || totalgrid == 28 ? 4 : 5
                               
                                let localizedIcon = NSLocalizedString(selectedIcon.uppercased(), comment: "")
                                let localizedIcon2 = NSLocalizedString(selectedIcon, comment: "")
                                print("localizedIcon " +  localizedIcon + " selectedIcon " +  selectedIcon + " localizedIcon2 " +  localizedIcon2)
                                if Locale.current.languageCode == "en" {
                                    if viewModel.userProfile.gender == true
                                    {
                                        if AllAssets.shared.girlAssets.contains(selectedIcon)
                                        {
                                            selectedIcon = selectedIcon
                                        }
                                        else
                                        {
                                            selectedIcon = localizedIcon2
                                        }
                                    }
                                    else
                                    {
                                        if AllAssets.shared.boyAssets.contains(selectedIcon)
                                        {
                                            selectedIcon = selectedIcon
                                        }
                                        else
                                        {
                                            selectedIcon = localizedIcon2
                                        }
                                    }
                                }
                                else if Locale.current.languageCode == "zh" {
                                    if viewModel.userProfile.gender == true
                                    {
                                        if AllAssets.shared.girlAssets.contains(selectedIcon)
                                        {
                                            selectedIcon = selectedIcon
                                        }
                                        else
                                        {
                                            selectedIcon = localizedIcon2
                                        }
                                    }
                                    else
                                    {
                                        if AllAssets.shared.boyAssets.contains(selectedIcon)
                                        {
                                            selectedIcon = selectedIcon
                                        }
                                        else
                                        {
                                            selectedIcon = localizedIcon2
                                        }
                                    }
                                }
                                else
                                {
                                    selectedIcon = getDisplayIcon(for: selectedIcon)
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
                        .padding(.bottom, 20)
                    }
                    .padding()
                    .background(Color("D6E3DF")) // Inner card background
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextContent(
                        text: "Buat Board Baru", size: 25, color: "FFFFFF", transparency: 1.0,
                        weight: "medium")
                }
            }
        }
    }
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon.replacingOccurrences(of: "GIRL_", with: "")
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon.replacingOccurrences(of: "BOY_", with: "")
                } else {
                    return icon
                    
                }
            }
        }
        else if Locale.current.languageCode == "zh" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon.replacingOccurrences(of: "GIRL_", with: "")
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon.replacingOccurrences(of: "BOY_", with: "")
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
    
    private func getDisplayIcon(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "GIRL_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "BOY_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
        }
        else if Locale.current.languageCode == "zh" {
            let localizedIcon = NSLocalizedString(icon.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "GIRL_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "BOY_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
        }

        else {
            return icon
        }
    }



    
    // MARK: - SearchIconView for Icon Selection
    
    struct SearchIconView: View {
        @Binding var selectedIcon: String
        @Environment(\.dismiss) private var dismiss
        @State private var searchText = ""
        @Environment(ProfileViewModel.self) private var viewModel

        // Select assets based on the device language (Indonesian or English)
        var allIcons: [String] {
            let lang = Locale.current.language.languageCode?.identifier ?? "id"
            if viewModel.userProfile.gender == true {
                if lang == "id" {
                    return AllAssets.shared.assets + AllAssets.shared.genderIndoAssets
                } else if lang == "zh" {
                    return AllAssets.shared.cinaAssets + AllAssets.shared.genderCinaAssets
                }
                else {
                    return AllAssets.shared.englishAssets + AllAssets.shared.genderEnglishAssets
                }
            }
            else {
                if lang == "id" {
                    return AllAssets.shared.assets + AllAssets.shared.genderIndoAssets
                } else if lang == "zh" {
                    return AllAssets.shared.cinaAssets + AllAssets.shared.genderCinaAssets
                }
                else {
                    return AllAssets.shared.englishAssets + AllAssets.shared.genderEnglishAssets
                }
            }
        }
        
        var filteredIcons: [String] {
            if !searchText.isEmpty {
                let lang = Locale.current.language.languageCode?.identifier ?? "id"
                if lang == "id" {
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
                }
                else {
                    let localizedIcon = NSLocalizedString(searchText, comment: "")
                    if viewModel.userProfile.gender == true {
                        if let girlAsset = allIcons.filter({ $0.contains("GIRL_") }).first(where: { $0.localizedCaseInsensitiveContains("GIRL_" + localizedIcon) }) {
                            return [girlAsset] + Array(allIcons.filter { $0.localizedCaseInsensitiveContains(localizedIcon) }.prefix(10))
                        } else {
                            return Array(allIcons.filter { $0.localizedCaseInsensitiveContains(localizedIcon) }.prefix(10))
                        }
                    } else {
                        if let boyAsset = allIcons.filter({ $0.contains("BOY_") }).first(where: { $0.localizedCaseInsensitiveContains("BOY_" + localizedIcon) }) {
                            return [boyAsset] + Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                        } else {
                            return Array(allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(10))
                        }
                    }
                }
            }
            else {
                return allIcons
            }
        }
        
        var body: some View {
            
            ZStack
            {
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
                
                VStack {
                    TextField(LocalizedStringKey("Cari Icon"), text: $searchText)
                        .padding(.horizontal, 16) // Add padding inside the text field
                        .padding(.vertical, 8) // Adjust vertical padding for height
                        .background(Color.white) // Set background color
                        .cornerRadius(16) // Make the corners rounded
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 0.86, green: 0.92, blue: 0.89), lineWidth: 2) // Set border color and width
                        )
                        .padding(.horizontal) // Add horizontal padding outside the text field

                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            ForEach(filteredIcons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                    dismiss()
                                }) {
                                    CustomButtonBoard(
                                        icon: (getDisplayIcon(for: icon)),
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
                                            selectedIcon = getDisplayIcon(for: icon)
                                            dismiss()
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden(true) // Sembunyikan tombol "Back" bawaan
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack{
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white) // Atur warna putih
                                .font(.system(size: 20, weight: .medium))
                            
                            TextContent(
                                text: "Kembali", size: 20, color: "FFFFFF",
                                transparency: 1.0,
                                weight: "medium")
                        }
                    }
                }
            }
        }
        
        private func getDisplayText(for icon: String) -> String {
            if Locale.current.languageCode == "en" {
                let localizedIcon = NSLocalizedString(icon, comment: "")
                let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
                if viewModel.userProfile.gender == true {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return icon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return icon
                    } else {
                        return icon
                        
                    }
                }
            }
            else if Locale.current.languageCode == "zh" {
                let localizedIcon = NSLocalizedString(icon, comment: "")
                let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
                if viewModel.userProfile.gender == true {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return icon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return icon
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
        
        private func getDisplayIcon(for icon: String) -> String {
            if Locale.current.languageCode == "en" {
                let localizedIcon = NSLocalizedString(icon.uppercased(), comment: "")
                if viewModel.userProfile.gender == true {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "GIRL_" + localizedIcon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "BOY_" + localizedIcon
                    } else {
                        return icon
                        
                    }
                }
            }
            else if Locale.current.languageCode == "zh" {
                let localizedIcon = NSLocalizedString(icon.uppercased(), comment: "")
                if viewModel.userProfile.gender == true {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "GIRL_" + localizedIcon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "BOY_" + localizedIcon
                    } else {
                        return icon
                        
                    }
                }
            }
            else {
                if viewModel.userProfile.gender == true {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "GIRL_" + icon
                    } else {
                        return icon
                        
                    }
                }
                else {
                    if AllAssets.shared.genderAssets.contains(icon) {
                        return "BOY_" + icon
                    } else {
                        return icon
                        
                    }
                }
            }
        }
    }
}
