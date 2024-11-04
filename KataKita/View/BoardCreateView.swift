import SwiftUI

struct BoardCreateView: View {
    @Binding var boardName: String
    @Binding var selectedIcon: String
    @Binding var gridSize: String
    @Binding var defaultButton: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var isIconPickerPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nama Board")) {
                    TextField("Masukkan nama board", text: $boardName)
                        .onAppear()
                    {
                        boardName = ""
                        selectedIcon = ""
                    }
                }
                
                Section(header: Text("Pilih Icon / Gambar")) {
                    VStack{
                        HStack {
                            Text("Icon yang dipilih: \(selectedIcon)")
                            
                            Spacer()
                            Button("Pilih Icon") {
                                isIconPickerPresented = true
                            }
                            
                        }
                        if selectedIcon != "" {
                            CustomButton(
                                icon: resolveIcon(for: selectedIcon),
                                text: selectedIcon,
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
                        }
                    }
                    .sheet(isPresented: $isIconPickerPresented) {
                        SearchIconView(selectedIcon: $selectedIcon)
                    }
                }
                
                Section(header: Text("Pilih Ukuran Grid")) {
                    Picker("Ukuran Grid", selection: $gridSize) {
                        Text("4 x 5").tag("4 x 5")
                        Text("4 x 7").tag("4 x 7")
                        Text("5 x 8").tag("5 x 8")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Buat Board Baru", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Selesai") {
                    if boardName != ""
                    {
                        defaultButton += 1
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

// MARK: - SearchIconView for Icon Selection
struct SearchIconView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    let allIcons = AllAssets.assets

    var filteredIcons: [String] {
        if searchText.isEmpty {
            return allIcons
        } else {
            return allIcons.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredIcons, id: \.self) { icon in
                Button(action: {
                     // Use dismiss here to close the view
                }) {
                    CustomButton(
                        icon: resolveIcon(for: icon),
                        text: icon,
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
                        isSystemImage: icon.contains("person.fill"),
                        action: {
                            selectedIcon = icon
                            dismiss()
                        }
                    )
                }
            }
            .searchable(text: $searchText)
            .navigationBarTitle("Cari Icon", displayMode: .inline)
        }
    }
}
