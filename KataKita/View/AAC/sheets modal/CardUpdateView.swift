import SwiftUI

struct CardUpdateView: View {
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
    
    @State private var name = ""
    @State private var category = Category.CORE
    @State private var type: CardType? = nil
    
    @State private var isImageType = false
    @State private var selectedCategory: Category = .CORE
    @State private var filteredAssets: [String] = []
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(BoardManager.self) private var boardManager
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if !navigateFromImage {
                        TextField("Tambah Kata Baru", text: $textToSpeak)
                            .onChange(of: textToSpeak) {
                                textToSpeak = textToSpeak.lowercased()
                                navigatesFromImage = false
                                filteredAssets = filterAssets(by: textToSpeak, for: viewModel.userProfile.gender)
                            }
                    }
                }
                
                HStack {
                    if let data = stickerManager.stickerImage,
                       let uiImage = UIImage(data: data) {
                        // Display the sticker image if available
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                            .onAppear {
                                self.type = .image(data)
                                isImageType = true
                                print("STICKER")
                            }
                    } else if let data = originalImageManager.imageFromLocal, let uiImage = UIImage(data: data) {
                        // Fallback to image from local if sticker is not set
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                            .onAppear {
                                self.type = .image(data)
                                isImageType = true
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
                                                isImageType = false
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
                            Label {
                                Text(category.rawValue)
                                    .foregroundColor(.primary)
                            } icon: {
                                Circle()
                                    .fill(category.getColor())
                                    .frame(width: 10, height: 10)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.inline) // Use inline or another style if needed
                }
                
                Spacer()
                
                
                CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                    if !textToSpeak.isEmpty {
                        handleDoneAction()
                        showAACSettings = false
                    }
                }
                .padding(.bottom, 20)
                
            }
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageCardView(
                    selectedColumnIndexValue: $selectedColumnIndexValue,
                    CardName: $textToSpeak
                )
            }
        }
    }
    
    private func handleDoneAction() {
        // Check if it's a sticker
        if stickerManager.stickerImage == nil && !isImageType {
            selectedIcon = textToSpeak.lowercased()
            self.type = .icon(selectedIcon)
        }

        // Handle the card creation
        
        if Locale.current.language.languageCode?.identifier == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(selectedIcon.lowercased()) {
                    selectedIcon = "GIRL_" + selectedIcon.uppercased()
                } else {
                    selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(selectedIcon.lowercased()) {
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
        if Locale.current.language.languageCode?.identifier == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    selectedIcon = "GIRL_" + textToSpeak.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
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
        boardManager.addCard(Card(name: textToSpeak, category: selectedCategory, type: self.type), column: selectedColumnIndexValue)

        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        stickerManager.stickerImage = nil  // Clear the sticker image after it's added

        // Dismiss the view
        self.addingCard = nil
    }
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.language.languageCode?.identifier == "en" {
            let localizedIcon = NSLocalizedString(icon.lowercased(), comment: "")
            if AllAssets.shared.genderAssets.contains(icon.lowercased()) {
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
        if Locale.current.language.languageCode?.identifier == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon.lowercased()) {
                    return "GIRL_" + icon.uppercased()
                } else {
                    return icon
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon.lowercased()) {
                    return "BOY_" + icon.uppercased()
                } else {
                    return icon
                    
                }
            }
        }
        else {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon.lowercased()) {
                    return "GIRL_" + icon.uppercased()
                } else {
                    return icon
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon.lowercased()) {
                    return "BOY_" + icon.uppercased()
                } else {
                    return icon
                    
                }
            }
        }
    }
}
