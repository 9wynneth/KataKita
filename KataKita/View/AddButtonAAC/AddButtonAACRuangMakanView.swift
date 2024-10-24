import SwiftUI
struct AddButtonAACRuangMakanView: View {
    @ObservedObject var viewModel: AACRuangMakanViewModel
    @State private var textToSpeak: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false

    @Binding var navigateTooAddImage: Bool
    @Binding var selectedSymbolImage: String
    @Binding var navigateFromSymbols: Bool
    @Binding var navigateFromImage: Bool
    @Binding var selectedSymbolName: String
    @Binding var selectedImage: UIImage?
    
    @Binding var categoryColor: String
    @Binding var selectedColumnIndex: [Card]
    
    @Binding var selectedColumnIndexValue: Int
    @Binding var selectedRowIndexValue: Int
    
    @State private var filteredAssets: [String] = []
    
    @Binding var showAACSettings: Bool
    
    
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
                
                HStack{
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
                                            textToSpeak = assetName
                                            
                                            // Keep only the selected asset
                                            filteredAssets = [assetName]
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
                           // showingAddImageView = true
                          //  navigatesFromImage = false
                        }
                    )
                    .opacity(navigatesFromImage ? 0 : 1)
                }
            }
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageAACView(viewModel: viewModel)
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    print("Done button pressed")
                    handleDoneAction()
                   // navigateToCekVMView = true
                    showAACSettings = false
                    
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
        filteredAssets = AllAssets.assets.filter { $0.lowercased().starts(with: textToSpeak.lowercased()) }
        navigatesFromImage = false
    }
    
    private func handleDoneAction() {
        let icon = textToSpeak.lowercased()
        let text = textToSpeak
        let color = categoryColor
        
        print("Handling done action: Icon: \(icon), Text: \(text), Background Color: \(color)")
        saveButtonData(icon: icon, text: text, backgroundColor: color, columnIndex: selectedColumnIndexValue, rowIndex: selectedRowIndexValue)
    }

    private func saveButtonData(icon: String, text: String, backgroundColor: String, columnIndex: Int, rowIndex: Int) {
        viewModel.addCard(icon: icon, text: text, backgroundColor: backgroundColor, columnIndex: rowIndex, rowIndex:  columnIndex)
        print("Saved card data: Icon: \(icon), Text: \(text), Background Color: \(backgroundColor)")
    }

}

