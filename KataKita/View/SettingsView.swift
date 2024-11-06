import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text("PROFIL PENGGUNA")) {
                    // Name TextField
                    HStack {
                        Text("Name")
                        TextField("Enter your name", text: $viewModel.userProfile.name)
                            .multilineTextAlignment(.trailing)
                    }
                    .onAppear {
                        print("Updated Profile:")
                        print("Name: \($viewModel.userProfile.name)")
                    }
                    
                    // Gender Selection
                    HStack {
                        Text("Gender")
                        Spacer()
                        Picker("", selection: $viewModel.userProfile.gender) {
                            Text("Laki-laki").tag(false)
                            Text("Perempuan").tag(true)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            .navigationTitle("Pengaturan")
            .navigationBarItems(
                trailing: Button("Done") {
                    viewModel.updateProfile(
                        name: viewModel.userProfile.name,
                        gender: viewModel.userProfile.gender
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail Page")
    }
}
