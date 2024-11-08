import AVFoundation
import SwiftUI

struct SettingsView: View {
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var isPersonalVoiceAvailable = false
    
    @State private var name = ""
    @State private var gender = false
    @State private var sound = false

    var body: some View {
        NavigationStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text(LocalizedStringKey("PROFIL PENGGUNA"))) {
                    // Name TextField
                    HStack {
                        Text(LocalizedStringKey("Nama"))
                        TextField(
                            LocalizedStringKey("Ketik namamu"), text: $name
                        )
                        .multilineTextAlignment(.trailing)
                    }

                    // Gender Selection
                    HStack {
                        Text(LocalizedStringKey("Jenis Kelamin"))
                        Spacer()
                        Picker("", selection: $gender) {
                            Text(LocalizedStringKey("Laki-laki")).tag(false)
                            Text(LocalizedStringKey("Perempuan")).tag(true)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                // aplikasi
                Section(header: Text(LocalizedStringKey("APLIKASI"))) {
                    // CUSTOM SUARA
                    HStack {
                        Text(LocalizedStringKey("Suara"))
                        Spacer()
                        Picker("", selection: $sound) {
                            Text("Default").tag(false)
                            Text("Custom").tag(true)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }

            }
            .navigationTitle("Pengaturan")
            .onAppear(perform: checkPersonalVoice)
            .onChange(of: viewModel.userProfile.sound) {
                if viewModel.userProfile.sound {
                    checkPersonalVoice()
                }
            }
            .onChange(of: name) {
                viewModel.userProfile.name = name
            }
            .onChange(of: gender) {
                viewModel.userProfile.gender = gender
                viewModel.updateProfile(name: name, gender: gender, sound: sound)
            }
            .onChange(of: sound) {
                viewModel.userProfile.sound = sound
            }
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
