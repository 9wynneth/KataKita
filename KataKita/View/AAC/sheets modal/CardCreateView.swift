import SwiftUI

func filterAssets(by input: String, for gender: Bool?) -> [String] {
    let lang = Locale.current.language.languageCode?.identifier ?? "id"

    // Determine the asset set based on device language
    let assets: [String]
    let girlAssets: [String]
    let boyAssets: [String]
    let genderAssets: [String]

    if lang == "id" {
        assets = AllAssets.shared.assets
        girlAssets = AllAssets.shared.girlAssets
        boyAssets = AllAssets.shared.boyAssets
        genderAssets = AllAssets.shared.genderIndoAssets
    } else if lang == "zh" {
        assets = AllAssets.shared.cinaAssets
        girlAssets = AllAssets.shared.girlCinaAssets
        boyAssets = AllAssets.shared.boyCinaAssets
        genderAssets = AllAssets.shared.genderCinaAssets
    } else {
        assets = AllAssets.shared.englishAssets
        girlAssets = AllAssets.shared.genderEnglishAssets
        boyAssets = AllAssets.shared.genderEnglishAssets
        genderAssets = AllAssets.shared.genderEnglishAssets
    }

    if let gender = gender {
        if gender {
            // Filter for girl-specific assets with "GIRL_" prefix
            let filteredGirlAssets = girlAssets.filter {
                $0.lowercased().starts(with: "GIRL_\(input.lowercased())")
            }
            if !filteredGirlAssets.isEmpty { return filteredGirlAssets }
        } else {
            // Filter for boy-specific assets with "BOY_" prefix
            let filteredBoyAssets = boyAssets.filter {
                $0.lowercased().starts(with: "BOY_\(input.lowercased())")
            }
            if !filteredBoyAssets.isEmpty { return filteredBoyAssets }
        }
    }
    
    // If no gender-specific match is found, fall back to general assets
    return (assets + genderAssets).filter {
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

    @State private var name = ""
    @State private var category = Category.CORE
    @State private var type: CardType? = nil

    @State private var isImageType = false
    @State private var selectedCategory: Category = .CORE
    @State private var filteredAssets: [String] = []

    @Binding var navigateFromImage: Bool
    @Binding var selectedColumnIndexValue: Int
    @Binding var showAACSettings: Bool
    @Binding var location: (Int, Int)

    init(
        _ navigateFromImage: Binding<Bool>,
        _ selectedColumnIndexValue: Binding<Int>,
        _ showAACSettings: Binding<Bool>,
        _ location: Binding<(Int, Int)> = Binding.constant((-1, -1))
    ) {
        self._navigateFromImage = navigateFromImage
        self._selectedColumnIndexValue = selectedColumnIndexValue
        self._showAACSettings = showAACSettings
        self._location = location
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "BDD4CE", transparency: 1)  
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Section {
                        VStack {
                            if !navigateFromImage {
                                VStack(alignment: .leading, spacing: 4) {
                                    TextContent(
                                        text: "NAMA ICON",
                                        size: 15,
                                        color: "FFFFFF",
                                        transparency: 1.0,
                                        weight: "regular"
                                    )
                                    VStack(alignment: .leading, spacing: 4) {
                                        TextField(
                                            LocalizedStringKey(
                                                "Tambah Kata Baru"),
                                            text: $textToSpeak
                                        )
                                        .onChange(of: textToSpeak) {
                                            textToSpeak = textToSpeak.lowercased()
                                            navigatesFromImage = false
                                            filteredAssets = filterAssets(by: textToSpeak, for: viewModel.userProfile.gender)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(
                                        color: Color.gray.opacity(0.3),
                                        radius: 10, x: 0, y: 5
                                    )
                                    .frame(height: 130)
                                
                                HStack {
                                    if let data = self.stickerManager.stickerImage, let uIImage = UIImage(data: data) {
                                        // Display the sticker image if available
                                        
                                        Image(uiImage: uIImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(20)
                                            .onAppear {
                                                if !self.showingAddImageView {
                                                    self.type = .image(data)
                                                    self.isImageType = true
                                                }
                                            }
                                            .onTapGesture {
                                                self.type = nil
                                                self.stickerManager.stickerImage = nil
                                                self.originalImageManager.imageFromLocal = nil
                                            }
                                    } else if let data = self.originalImageManager.imageFromLocal, let uiImage = UIImage(data: data) {
                                        // Fallback to image from local if sticker is not set
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(20)
                                            .onAppear {
                                                if !self.showingAddImageView {
                                                    self.type = .image(data)
                                                    self.isImageType = true
                                                }
                                            }
                                            .onTapGesture {
                                                self.type = nil
                                                self.originalImageManager.imageFromLocal = nil
                                                self.stickerManager.stickerImage = nil
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
                                                                if
                                                                    let board = self.boardManager.boards.first(where: { $0.id == self.boardManager.selectedID }),
                                                                    var card = board.cards[safe: self.location.0]?[safe: self.location.1]
                                                                {
                                                                    let localizedIcon = NSLocalizedString(assetName.uppercased(), comment: "")
                                                                    self.type = .icon(getDisplayIcon(for: localizedIcon))
                                                                }
                                                                else {
                                                                    
                                                                    self.type = .icon(getDisplayIcon(for: assetName))
                                                                }
                                                                
                                                                navigatesFromImage = true
                                                                textToSpeak = assetName
                                                                if textToSpeak.hasPrefix("GIRL_") {
                                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "GIRL_", with: "")
                                                                    isGender = true
                                                                } else if textToSpeak.hasPrefix("BOY_") {
                                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "BOY_", with: "")
                                                                    isGender = true
                                                                } else {
                                                                    isGender = false
                                                                }
                                                                filteredAssets = [assetName]
                                                                isImageType = false
                                                            }
                                                        )
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
                                    if self.stickerManager.stickerImage == nil && self.originalImageManager.imageFromLocal == nil {
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
                                                self.type = nil
                                                showingAddImageView = true
                                                navigatesFromImage = false
                                            }
                                        )
                                        .opacity(!navigatesFromImage ? 1 : 0)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            Section(
                                header:
                                    HStack {
                                        TextContent(
                                            text: "PILIH KATEGORI", size: 15,
                                            color: "FFFFFF", transparency: 1.0,
                                            weight: "regular")
                                        Spacer()  // Pushes the text to the left
                                    }
                                    .padding(.leading)  // Optional: Adds some padding to the left
                            ) {
                                Picker("Kategori", selection: $selectedCategory)
                                {
                                    ForEach(Category.allCases, id: \.self) {
                                        category in
                                        Text(category.rawValue)
                                            .tag(category)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            Color(UIColor.systemGray4),
                                            lineWidth: 1)
                                )
                                .accentColor(.blue)  // Sets the selected text color to blue
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                        if !textToSpeak.isEmpty {
                            handleDoneAction()
                        }
                    }
                    .padding(.bottom, 20)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextContent(
                        text: "Tambah Icon Baru", size: 25, color: "FFFFFF",
                        transparency: 1.0,
                        weight: "medium")
                }
            }
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageCardView(
                    selectedColumnIndexValue: $selectedColumnIndexValue,
                    CardName: $textToSpeak
                )
                .onAppear {
                    self.type = nil
                }
            }
        }
        .onAppear {
            print(self.location)
            if let board = self.boardManager.boards.first(where: { $0.id == self.boardManager.selectedID }) {
                print(board)
                if let card = board.cards[safe: self.location.0]?[safe: self.location.1] {
                    print(card)
                    self.textToSpeak = NSLocalizedString(card.name, comment: "")
                    self.selectedCategory = card.category
                    if case let .image(image) = card.type {
                        self.stickerManager.stickerImage = image
                    }
                }
            }
        }
        .onDisappear{
            
        }
    }

    private func handleDoneAction() {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(textToSpeak.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "GIRL_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "BOY_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
        }
        else         if Locale.current.languageCode == "zh" {
            let localizedIcon = NSLocalizedString(textToSpeak.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "GIRL_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "BOY_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
        }
        else {
            textToSpeak = NSLocalizedString(textToSpeak, comment: "")
        }
        
        if
            let board = self.boardManager.boards.first(where: { $0.id == self.boardManager.selectedID }),
            var card = board.cards[safe: self.location.0]?[safe: self.location.1]
        {
            
            card.name = self.textToSpeak
            card.type = self.type
            card.category = self.selectedCategory
            
            self.boardManager.updateCard(
                column: self.location.0,
                row: self.location.1,
                updatedCard: card
            )
        }
        else
        {
            self.boardManager.addCard(
                Card(
                    name: self.textToSpeak,
                    category: self.selectedCategory,
                    type: self.type
                ),
                column: selectedColumnIndexValue
            )
        }

        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        stickerManager.stickerImage = nil  // Clear the sticker image after it's added
        
        // Dismiss the view
        self.addingCard = nil
        self.showAACSettings = false
        
    }

    private func getDisplayText(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
        }
        else         if Locale.current.languageCode == "zh" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon2
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

// Updated SearchIconView

struct SearchIconsView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @Environment(ProfileViewModel.self) private var viewModel

    // Step 1: Fetch all assets localized to the user's language
    var localizedAssets: [(original: String, localized: String)] {
        let allAssets = AllAssets.shared.assets + AllAssets.shared.boyEnglishAssets + AllAssets.shared.boyAssets + AllAssets.shared.girlAssets + AllAssets.shared.genderAssets + AllAssets.shared.girlEnglishAssets
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
            TextField(LocalizedStringKey("Cari Icon"), text: $searchText)
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
        .navigationBarTitle(LocalizedStringKey("Cari Icon"), displayMode: .inline)
    }
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.languageCode == "en" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
        }
        else         if Locale.current.languageCode == "zh" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon2
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
        else         if Locale.current.languageCode == "zh" {
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
}
