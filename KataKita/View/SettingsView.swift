import AVFoundation
import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var isPersonalVoiceAvailable = false

    var body: some View {
        NavigationStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text("PROFIL PENGGUNA")) {
                    // Name TextField
                    HStack {
                        Text("Name")
                        TextField(
                            "Enter your name", text: $viewModel.userProfile.name
                        )
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
                // aplikasi
                Section(header: Text("APLIKASI")) {
                    // CUSTOM SUARA
                    HStack {
                        Text("Suara")
                        Spacer()
                        Picker("", selection: $viewModel.userProfile.sound) {
                            Text("Default").tag(false)
                            Text("Custom").tag(true)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.userProfile.sound) { newValue in
                            if newValue {
                                checkPersonalVoice()
                            }
                        }
                    }
                }

            }
            .navigationTitle("Pengaturan")
            .navigationBarItems(
                trailing: Button("Done") {
                    viewModel.updateProfile(
                        name: viewModel.userProfile.name,
                        gender: viewModel.userProfile.gender,
                        sound: viewModel.userProfile.sound
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear(perform: checkPersonalVoice)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIApplication.didBecomeActiveNotification)
            ) { _ in
                checkPersonalVoice()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Personal Voice Not Set"),
                    message: Text(
                        "To set up Personal Voice, please go to Settings > Accessibility > Speech > Personal Voice."
                    ),
                    primaryButton: .default(
                        Text("Open Settings"), action: openSettings),
                    secondaryButton: .cancel(
                        Text("Cancel"),
                        action: {
                            viewModel.userProfile.sound = false
                        })
                )
            }

        }
    }

    private func checkPersonalVoice() {
        Task {
            isPersonalVoiceAvailable = await viewModel.fetchPersonalVoices()  // Check Personal Voice status
            if viewModel.userProfile.sound && !isPersonalVoiceAvailable {
                viewModel.userProfile.sound = false  // Reset to default if Personal Voice isn't set
                showAlert = true  // Show alert to guide user to settings
            }
        }
    }

    private func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }

}

#Preview {
    SettingsView()
}
