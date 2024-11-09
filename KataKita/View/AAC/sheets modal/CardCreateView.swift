import SwiftUI

func filterAssets(by input: String, for gender: Bool?) -> [String] {
    // Create an instance or use a shared instance of AllAssets
    let assets = Locale.current.languageCode == "id" ? AllAssets.shared.assets : AllAssets.englishAssets
    let girlAssets = Locale.current.languageCode == "id" ? AllAssets.shared.girlAssets : AllAssets.shared.girlAssets
    let boyAssets = Locale.current.languageCode == "id" ? AllAssets.shared.boyAssets : AllAssets.shared.boyAssets
    let genderAssets = AllAssets.shared.genderAssets

    if let gender = gender {
        if gender {
            // Filter for girl-specific assets with "GIRL_" prefix
            let girlAssets = AllAssets.shared.girlAssets.filter {
                $0.lowercased().starts(with: "girl_\(input.lowercased())")
            }
            if !girlAssets.isEmpty { return girlAssets }
        } else {
            // Filter for boy-specific assets with "BOY_" prefix
            let boyAssets = AllAssets.shared.boyAssets.filter {
                $0.lowercased().starts(with: "boy_\(input.lowercased())")
            }
            if !boyAssets.isEmpty { return boyAssets }
        }
    }

    // If no gender-specific match is found, fall back to general assets
    return (AllAssets.shared.assets + AllAssets.shared.girlAssets.map { $0.replacingOccurrences(of: "GIRL_", with: "") }
            + AllAssets.shared.boyAssets.map { $0.replacingOccurrences(of: "BOY_", with: "") }).filter {
        $0.lowercased().starts(with: input.lowercased())
    }
}


// Updated CardCreateView
struct CardCreateView: View {
    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(BoardManager.self) private var boardManager

    @State private var textToSpeak: String = ""
    @State private var selectedIcon: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false
    @State private var addingCard: Int? = nil
    @State private var isGender = false
       
    @Binding var navigateFromImage: Bool
    @Binding var selectedColumnIndexValue: Int
    @Binding var showAACSettings: Bool
    
    @State private var isIconTypeImage = false
    @State private var selectedCategory: Category = .CORE
    @State private var filteredAssets: [String] = []
    


    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if !navigateFromImage {
                        TextField("Tambah Kata Baru", text: $textToSpeak)
                            .onChange(of: textToSpeak) { newValue in
                                textToSpeak = newValue.lowercased()
                                navigatesFromImage = false
                                filteredAssets = filterAssets(by: textToSpeak, for: viewModel.userProfile.gender)
                            }
                    }
                }
                
                HStack {
                    
                    if let stickerURL = stickerManager.stickerImage,
                       let stickerImage = UIImage(contentsOfFile: stickerURL.path) {
                        // Display the sticker image if available
                        Image(uiImage: stickerImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                            .onAppear {
                                isIconTypeImage = true
                                print("STICKER")
                            }
                    } else if let imageURL = originalImageManager.imageFromLocal, let uiImage = UIImage(contentsOfFile: imageURL.path) {
                        // Fallback to image from local if sticker is not set
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                            .onAppear {
                                isIconTypeImage = true
                                print("ORIGINALc")
                            }
                    } else {
                        // Display icons if no image is selected
                        if !filteredAssets.isEmpty {
                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(filteredAssets.prefix(3), id: \.self) { assetName in
                                        CustomButtonSearch(
                                            icon: getDisplayIcon(for: assetName),
                                            text: getDisplayText(for: assetName),
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
                                            isSystemImage: assetName.contains("person.fill"),
                                            action: {
                                                navigatesFromImage = true
                                                textToSpeak = assetName
                                                if textToSpeak.hasPrefix("GIRL_") {
                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "GIRL_", with: "")
                                                    isGender = true
                                                } else if textToSpeak.hasPrefix("BOY_") {
                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "BOY_", with: "")
                                                    isGender = true
                                                }
                                                else {
                                                    isGender = false
                                                }
                                                filteredAssets = [assetName]
                                                isIconTypeImage = false
                                            }
                                        )
                                        .onAppear {
                                            print("INI YAAA " + getDisplayText(for: assetName) + "OKEE " + assetName)
                                        }
                                    }
                                }
                            }
                        } else if !textToSpeak.isEmpty {
                            CustomButtonSearch(
                                text: textToSpeak,
                                width: 100,
                                height: 100,
                                font: 20,
                                bgColor: "#FFFFFF",
                                bgTransparency: 1.0,
                                fontColor: "#000000",
                                fontTransparency: 1.0,
                                cornerRadius: 20,
                                action: {
                                    navigatesFromImage = true
                                }
                            )
                        }
                    }
                    
                    CustomButton(
                        icon: "plus",
                        width: 100,
                        height: 100,
                        font: 40,
                        iconWidth: 50,
                        iconHeight: 50,
                        bgColor: "#FFFFFF",
                        bgTransparency: 1.0,
                        fontColor: "#000000",
                        fontTransparency: 1.0,
                        cornerRadius: 20,
                        isSystemImage: true,
                        action: {
                            showingAddImageView = true
                            navigatesFromImage = false
                        }
                    )
                    .opacity(navigatesFromImage ? 0 : 1)
                }
                
                Section(header: Text("Pilih Kategori")) {
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .foregroundColor(category.getColor())
                                .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .onAppear {
                
            }
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageCardView(
                    selectedColumnIndexValue: $selectedColumnIndexValue,
                    CardName: $textToSpeak
                )
//                .onDisappear {
//                      // Reset image selection when navigating back
//                      originalImageManager.imageFromLocal = nil
//                      stickerManager.stickerImage = nil
//                  }
            }
            .navigationBarItems(
                trailing: Button(LocalizedStringKey("Selesai")) {
                    if !textToSpeak.isEmpty {
                        handleDoneAction()
                        showAACSettings = false
                    }
                }
            )
        }
    }
    
    private func handleDoneAction() {
        // Check if it's a sticker
        if let stickerURL = stickerManager.stickerImage {
            selectedIcon = stickerURL.path
        } else if isIconTypeImage {
            selectedIcon = originalImageManager.imageFromLocal?.path ?? ""
        } else {
            selectedIcon = textToSpeak.lowercased()
        }

        // Handle the card creation
        
        if Locale.current.languageCode == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.genderAssets.contains(selectedIcon.lowercased()) {
                    selectedIcon = "GIRL_" + selectedIcon.uppercased()
                } else {
                    selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                }
            }
            else {
                if AllAssets.genderAssets.contains(selectedIcon.lowercased()) {
                    selectedIcon = "BOY_" + selectedIcon.uppercased()
                } else {
                    selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                }
            }
        }
        else {
            selectedIcon = NSLocalizedString(selectedIcon, comment: "")
        }
        let color = selectedCategory

        // Localize only when displaying in SwiftUI
        if Locale.current.languageCode == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.genderAssets.contains(textToSpeak.lowercased()) {
                    selectedIcon = "GIRL_" + textToSpeak.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
            else {
                if AllAssets.genderAssets.contains(textToSpeak.lowercased()) {
                    selectedIcon = "BOY_" + textToSpeak.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
        }
        else {
            textToSpeak = NSLocalizedString(textToSpeak, comment: "")
        }

        print("Handling done action: Icon: \(selectedIcon), Text: \(textToSpeak), Background Color: \(color)")

        // Add card to board
        boardManager.addCard(Card(name: textToSpeak, icon: selectedIcon, category: selectedCategory, isIconTypeImage: isIconTypeImage), column: selectedColumnIndexValue)


        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        stickerManager.stickerImage = nil  // Clear the sticker image after it's added

        // Dismiss the view
        self.addingCard = nil
    }
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon.lowercased(), comment: "")
            if AllAssets.genderAssets.contains(icon.lowercased()) {
                return localizedIcon
            }
            else {
                return icon
                
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
            if viewModel.userProfile.gender == true {
                if AllAssets.genderAssets.contains(icon.lowercased()) {
                    return "GIRL_" + icon.uppercased()
                } else {
                    return icon
                }
            }
            else {
                if AllAssets.genderAssets.contains(icon.lowercased()) {
                    return "BOY_" + icon.uppercased()
                } else {
                    return icon
                    
                }
            }
        }
        else {
            if viewModel.userProfile.gender == true {
                if AllAssets.genderAssets.contains(icon.lowercased()) {
                    return "GIRL_" + icon.uppercased()
                } else {
                    return icon
                }
            }
            else {
                if AllAssets.genderAssets.contains(icon.lowercased()) {
                    return "BOY_" + icon.uppercased()
                } else {
                    return icon
                    
                }
            }
        }
    }
}

// Updated SearchIconView

struct SearchIconsView: View {
    @Environment(ProfileViewModel.self) private var viewModel

    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Step 1: Fetch all assets localized to the user's language
    var localizedAssets: [(original: String, localized: String)] {
        let allAssetsInstance = AllAssets()
        let allAssets = allAssetsInstance.assets + allAssetsInstance.boyAssets + allAssetsInstance.girlAssets + allAssetsInstance.genderAssets
        return allAssets.map { asset in
            (original: asset, localized: NSLocalizedString(asset, comment: ""))
        }
    }
    
    // Step 2: Filter assets by localized names matching the English input
    var filteredIcons: [(original: String, localized: String)] {
        if searchText.isEmpty {
            return localizedAssets
        } else {
            // Filter based on localized names in Indonesian that match English input
            return localizedAssets.filter { _, localized in
                let englishTerm = NSLocalizedString(localized, tableName: "Localizable", comment: "")
                return englishTerm.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            TextField("Cari Icon", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                    ForEach(filteredIcons, id: \.original) { icon in
                        Button(action: {
                            selectedIcon = icon.original
                            dismiss()
                        }) {
                            CustomButtonSearch(
                                icon: getDisplayText(for: icon.original),
                                text: getDisplayText(for: icon.original),
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
                                isSystemImage: icon.original.contains("person.fill")) {
                                    selectedIcon = icon.localized
                                    dismiss()
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
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon.lowercased(), comment: "")
            if AllAssets.genderAssets.contains(icon.lowercased()) {
                
                return localizedIcon
            }
            else {
                return icon
                
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
            let localizedText = NSLocalizedString(icon, comment: "")
            return localizedText
        }
    }
}
