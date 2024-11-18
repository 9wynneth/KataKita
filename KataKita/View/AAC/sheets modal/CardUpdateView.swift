import SwiftUI



// Updated CardCreateView
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
            ZStack {
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
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
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .frame(height: 130)
                                
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
                                                guard let data = stickerImage.pngData() else {
                                                    return
                                                }
                                                self.type = .image(data)
                                                isImageType = true
                                            }
                                    } else if let imageURL = originalImageManager.imageFromLocal,
                                              let uiImage = UIImage(contentsOfFile: imageURL.path) {
                                        // Fallback to image from local if sticker is not set
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(20)
                                            .onAppear {
                                                guard let data = uiImage.pngData() else {
                                                    return
                                                }
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
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        VStack(alignment: .leading, spacing: 4){
                            Section(header:
                                        HStack {
                                TextContent(
                                    text: "PILIH KATEGORI", size: 15, color: "FFFFFF", transparency: 1.0,
                                    weight: "regular")
                                Spacer() // Pushes the text to the left
                            }
                                .padding(.leading) // Optional: Adds some padding to the left
                            ) {
                                Picker("Kategori", selection: $selectedCategory) {
                                    ForEach(Category.allCases, id: \.self) { category in
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
                                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                                )
                                .accentColor(.blue) // Sets the selected text color to blue
                                .padding(.horizontal)
                            }
                        }
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
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextContent(
                        text: "Tambah Icon Baru", size: 25, color: "FFFFFF", transparency: 1.0,
                        weight: "medium")
                }
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
        
        // Localize only when displaying in SwiftUI
        if Locale.current.language.languageCode?.identifier == "en" {
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
        if stickerManager.stickerImage == nil && !isImageType {
            selectedIcon = textToSpeak.lowercased()
            self.type = .icon(selectedIcon)
        }
        print("icon " + textToSpeak)
        
        boardManager.addCard(Card(name: textToSpeak, category: selectedCategory, type: self.type), column: selectedColumnIndexValue)
        
        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        stickerManager.stickerImage = nil  // Clear the sticker image after it's added
        
        // Dismiss the view
        self.addingCard = nil
    }
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.language.languageCode?.identifier == "en" {
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
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        if lang == "en" {
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
