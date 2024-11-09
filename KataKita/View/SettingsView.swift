import AVFoundation
import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var isPersonalVoiceAvailable = false

    var body: some View {
        NavigationStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text(LocalizedStringKey("PROFIL PENGGUNA"))) {
                    // Name TextField
                    HStack {
                        Text(LocalizedStringKey("Nama"))
                        TextField(
                            LocalizedStringKey("Ketik namamu"), text: $viewModel.userProfile.name
                        )
                        .multilineTextAlignment(.trailing)
                        .onChange(of: viewModel.userProfile.name) { newValue in
                            viewModel.updateProfile(
                                name: viewModel.userProfile.name,
                                gender: viewModel.userProfile.gender,
                                sound: viewModel.userProfile.sound
                            )
                        }
                    }

                    // Gender Selection
                    HStack {
                        Text(LocalizedStringKey("Jenis Kelamin"))
                        Spacer()
                        Picker("", selection: $viewModel.userProfile.gender) {
                            Text(LocalizedStringKey("Laki-laki")).tag(false)
                            Text(LocalizedStringKey("Perempuan")).tag(true)
                        }
                        .onChange(of: viewModel.userProfile.gender) { newValue in
                            viewModel.updateProfile(
                                name: viewModel.userProfile.name,
                                gender: viewModel.userProfile.gender,
                                sound: viewModel.userProfile.sound
                            )
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                // aplikasi
//                Section(header: Text(LocalizedStringKey("APLIKASI"))) {
//                    // CUSTOM SUARA
//                    HStack {
//                        Text(LocalizedStringKey("Suara"))
//                        Spacer()
//                        Picker("", selection: $viewModel.userProfile.sound) {
//                            Text("Default").tag(false)
//                            Text("Custom").tag(true)
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                        .onChange(of: viewModel.userProfile.sound) { newValue in
//                            if newValue {
//                                checkPersonalVoice()
//                            }
//                        }
//                    }
//                }

            }
            .navigationTitle("Pengaturan")
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
