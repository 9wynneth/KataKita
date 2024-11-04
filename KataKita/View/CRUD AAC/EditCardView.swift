import SwiftUI
struct EditCardView: View {
    @ObservedObject var viewModel: AACTemplateViewModel
    @State private var textToSpeak: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false

    @Binding var CardName: String
    @Binding var CardPicture: String
    
    @Binding var categoryColor: String
    @Binding var selectedColumnIndex: [Card]
    
    @Binding var selectedColumnIndexValue: Int
    @Binding var selectedRowIndexValue: Int
    
    @State private var filteredAssets: [String] = []
    
    @Binding var isEditingCard: Bool
    
    @Binding var navigateFromFile: Bool
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(CardName, text: $CardName)
                        .onChange(of: CardName) { newValue in
                            CardName = newValue.lowercased()
                            navigatesFromImage = false
                            filterSuggestions()
                        }
                        .onAppear()
                    {
                        CardName = CardName.lowercased()
                        navigatesFromImage = false
                        filterSuggestions()
                    }
                    
                }
                
                HStack{
                    if navigateFromFile { //true
                        Image(uiImage: UIImage(named: CardPicture)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                    }
                    else //false
                    {
                        // Display filtered suggestions when there is input
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
                                            bgColor: categoryColor,
                                            bgTransparency: 1.0,
                                            fontColor: "#000000",
                                            fontTransparency: 1.0,
                                            cornerRadius: 20,
                                            isSystemImage: assetName.contains("person.fill"),
                                            action: {
                                                navigatesFromImage = true
                                                CardName = assetName
                                                
                                                // Keep only the selected asset
                                                filteredAssets = [assetName]
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        else if !CardName.isEmpty
                        {
                            CustomButton(
                                text: CardName,
                                width: 100,
                                height: 100,
                                font: 20,
                                bgColor: categoryColor,
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
                        bgColor: categoryColor,
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
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageAACTemplateView(
                    viewModel: viewModel,
                    imageFromLocal: CardName,
                    categoryColor: $categoryColor,
                    selectedColumnIndex: $selectedColumnIndex,
                    selectedColumnIndexValue: $selectedColumnIndexValue, // Pass column index
                    selectedRowIndexValue: $selectedRowIndexValue, CardName: $CardName
                )
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    if !CardName.isEmpty {
                        handleDoneAction()
                       // navigateToCekVMView = true
                        
                    }
                    else if navigateFromFile {
                        handleDoneAction()
                    }
                    isEditingCard = false
                }
            )
        }
        .onAppear {
            print("View appeared, showingAddImageView: \(showingAddImageView)")
            print("Current category color: \(categoryColor)")
            print(selectedColumnIndexValue)
            print(selectedRowIndexValue)
        }
    }
    
    // Function to filter suggestions based on the user's input
    private func filterSuggestions() {
        filteredAssets = AllAssets.assets.filter { $0.lowercased().starts(with: CardName.lowercased()) }
        navigatesFromImage = false
    }
    
    private func handleDoneAction() {
        let icon = CardName.lowercased()
        let text = CardName
        let color = categoryColor
        
        print("Handling done action: columnIndex: \(selectedColumnIndexValue), rowIndex: \(selectedRowIndexValue), Background Color: \(color)")
        saveButtonData(icon: icon, text: text, backgroundColor: color, columnIndex: selectedColumnIndexValue, rowIndex: selectedRowIndexValue)
       
    }

    private func saveButtonData(icon: String, text: String, backgroundColor: String, columnIndex: Int, rowIndex: Int) {
        
        viewModel.updateCard(columnIndex: rowIndex, rowIndex: columnIndex, newIcon: CardName, newName: CardName)
        print("Saved card data: columnIndex: \(columnIndex), rowIndex: \(rowIndex), Background Color: \(backgroundColor)")
    }
}
