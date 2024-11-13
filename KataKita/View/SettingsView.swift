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
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                // Profil Pengguna Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profil pengguna")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Name TextField
                    HStack {
                        Text("Nama")
                        Spacer()
                        TextField("Ketik namamu", text: $name)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.gray)
                    }
                    
                    // Gender Selection
                    HStack {
                        Text("Jenis Kelamin")
                        Spacer()
                        Picker("", selection: $gender) {
                            Text("Laki-laki").tag(false)
                            Text("Perempuan").tag(true)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                        Text("Pengaturan")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .background(Color.black)
            .onAppear(perform: checkPersonalVoice)
            .onChange(of: viewModel.userProfile.sound) {
                if viewModel.userProfile.sound {
                    checkPersonalVoice()
                }
            }
            .onAppear {
                gender = viewModel.userProfile.gender
                name = viewModel.userProfile.name
                sound = viewModel.userProfile.sound
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
