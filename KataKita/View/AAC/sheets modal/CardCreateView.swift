import SwiftUI// Helper function to filter assets based on input and gender

func filterAssets(by input: String, for gender: Bool?) -> [String] {
    if let gender = gender {
        if gender {
            // Filter for girl-specific assets with "GIRL_" prefix
            let girlAssets = AllAssets.girlAssets.filter {
                $0.lowercased().starts(with: "girl_\(input.lowercased())")
            }
            if !girlAssets.isEmpty { return girlAssets }
        } else {
            // Filter for boy-specific assets with "BOY_" prefix
            let boyAssets = AllAssets.boyAssets.filter {
                $0.lowercased().starts(with: "boy_\(input.lowercased())")
            }
            if !boyAssets.isEmpty { return boyAssets }
        }
    }
    
    // If no gender-specific match is found, fall back to general assets
    return (AllAssets.assets + AllAssets.girlAssets.map { $0.replacingOccurrences(of: "GIRL_", with: "") }
            + AllAssets.boyAssets.map { $0.replacingOccurrences(of: "BOY_", with: "") }).filter {
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
    @State private var imageFromLocal: URL?
    @State private var isGender = false
    
    @Binding var navigateFromImage: Bool
    @Binding var selectedColumnIndexValue: Int
    @Binding var showAACSettings: Bool
    
    @State private var isIconTypeImage = false
    @State private var selectedCategory: Category = .CORE
    @State private var filteredAssets: [String] = []
    @StateObject private var viewModel = ProfileViewModel()
    
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
                    if let imageURL = imageFromLocal, let uiImage = UIImage(contentsOfFile: imageURL.path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                            .onAppear {
                                isIconTypeImage = true
                            }
                    } else {
                        if !filteredAssets.isEmpty {
                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(filteredAssets.prefix(3), id: \.self) { assetName in
                                        CustomButton(
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
                            CustomButton(
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
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageCardView(
                    selectedColumnIndexValue: $selectedColumnIndexValue,
                    CardName: $textToSpeak,
                    imageFromLocal: $imageFromLocal
                )
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
        if isIconTypeImage {
            selectedIcon = imageFromLocal?.path ?? ""
        } else {
            selectedIcon = textToSpeak.lowercased()
//            if isGender {
//                if viewModel.userProfile.gender {
//                    selectedIcon = "GIRL_" + selectedIcon
//                }
//                else {
//                    selectedIcon = "BOY_" + selectedIcon
//                }
//            }
        }
        let icon = selectedIcon
        let text = textToSpeak
        let color = selectedCategory
        
        print("Handling done action: Icon: \(icon), Text: \(text), Background Color: \(color)")
        BoardManager.shared.addCard(Card(name: text, icon: icon, category: selectedCategory, isIconTypeImage: isIconTypeImage), column: selectedColumnIndexValue)
        self.addingCard = nil
    }
}

// Updated SearchIconView
struct SearchIconsView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @StateObject private var viewModel = ProfileViewModel()
    
    var filteredIcons: [String] {
        filterAssets(by: searchText, for: viewModel.userProfile.gender)
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

                            if selectedIcon.hasPrefix("GIRL_") {
                                selectedIcon = selectedIcon.replacingOccurrences(of: "GIRL_", with: "")
                            } else if selectedIcon.hasPrefix("BOY_") {
                                selectedIcon = selectedIcon.replacingOccurrences(of: "BOY_", with: "")
                            }

                            dismiss()
                        }) {
                            CustomButton(
                                icon: resolveIcon(for: icon),
                                text: icon,
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
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Cari Icon", displayMode: .inline)
    }
}
