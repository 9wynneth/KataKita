import SwiftUI

struct CardCreateView: View {
    @State private var textToSpeak: String = ""
    @State private var selectedIcon: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false
    @State private var addingCard: Int? = nil
    @State private var imageFromLocal: URL?  // New State to store image URL
    @Environment(BoardManager.self) private var boardManager
    
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
                                filterSuggestions()
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
                        
                    }
                    else
                    {
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
                                            
                                            // Keep only the selected asset
                                            filteredAssets = [assetName]
                                            isIconTypeImage = false
                                        }
                                    )
                                }
                            }
                        }
                    }
                    else if !textToSpeak.isEmpty
                    {
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
                    .pickerStyle(SegmentedPickerStyle())
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
                trailing: Button("Done") {
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
        }
        else
        {
            selectedIcon = textToSpeak.lowercased()
        }
        let icon = selectedIcon
        let text = textToSpeak
        let color = selectedCategory
        
        print("Handling done action: Icon: \(icon), Text: \(text), Background Color: \(color)")
        boardManager.addCard(Card(name: text, icon: icon, category: selectedCategory, isIconTypeImage: isIconTypeImage), column: selectedColumnIndexValue)
        self.addingCard = nil
    }
    
    private func filterSuggestions() {
        filteredAssets = AllAssets.assets.filter { $0.lowercased().starts(with: textToSpeak.lowercased()) }
        navigatesFromImage = false
    }
}
