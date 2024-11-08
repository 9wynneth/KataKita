import SwiftUI// Helper function to filter assets based on input and gender

func filterAssets(by input: String, for gender: Bool?) -> [String] {
    // Determine the asset set based on device language
    let assets = Locale.current.languageCode == "id" ? AllAssets.assets : AllAssets.englishAssets
    let girlAssets = Locale.current.languageCode == "id" ? AllAssets.girlAssets : AllAssets.girlAssets
    let boyAssets = Locale.current.languageCode == "id" ? AllAssets.boyAssets : AllAssets.boyAssets

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
    return (assets + girlAssets.map { $0.replacingOccurrences(of: "GIRL_", with: "") }
            + boyAssets.map { $0.replacingOccurrences(of: "BOY_", with: "") }).filter {
        $0.lowercased().starts(with: input.lowercased())
    }
}


// Updated CardCreateView
struct CardCreateView: View {
    @State private var textToSpeak: String = ""
    @State private var selectedIcon: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false
    @State private var addingCard: Int? = nil
    @State private var isGender = false
    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager

    
    @Binding var navigateFromImage: Bool
    @Binding var selectedColumnIndexValue: Int
    @Binding var showAACSettings: Bool
    
    @State private var isIconTypeImage = false
    @State private var selectedCategory: Category = .CORE
    @State private var filteredAssets: [String] = []
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(BoardManager.self) private var boardManager

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
                                            icon: resolveIcon(for: assetName),
                                            text: assetName,
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
                    
                    CustomButtonSearch(
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
        let icon = NSLocalizedString(selectedIcon, comment: "")
        let color = selectedCategory

        // Localize only when displaying in SwiftUI
        let localizedText = NSLocalizedString(textToSpeak, comment: "")

        print("Handling done action: Icon: \(icon), Text: \(localizedText), Background Color: \(color)")

        // Add card to board
        boardManager.addCard(Card(name: localizedText, icon: icon, category: selectedCategory, isIconTypeImage: isIconTypeImage), column: selectedColumnIndexValue)


        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        stickerManager.stickerImage = nil  // Clear the sticker image after it's added

        // Dismiss the view
        self.addingCard = nil
    }


}

// Updated SearchIconView

struct SearchIconsView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @EnvironmentObject var viewModel: ProfileViewModel
    
    // Step 1: Fetch all assets localized to the user's language
    var localizedAssets: [(original: String, localized: String)] {
        let allAssets = AllAssets.assets + AllAssets.boyAssets + AllAssets.girlAssets
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
                                icon: resolveIcon(for: icon.localized),
                                text: icon.original,
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
}
