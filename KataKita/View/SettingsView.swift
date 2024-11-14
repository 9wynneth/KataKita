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
        ZStack {
            Color(hex: "BDD4CE", transparency: 1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Settings Header
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    TextContent(
                        text: "Pengaturan", size: 25, color: "FFFFFF", transparency: 1.0,
                        weight: "medium")
                }
                .padding(.top, 40)
                .padding(.bottom, 50)
                
                // Profile Card
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(radius: 5)
                    
                    VStack(spacing: 20) {
                        // Profile Section
                        HStack(spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            TextContent(
                                text: name.isEmpty ? "Ve" : name, size: 35, color: "000000", transparency: 1.0,
                                weight: "regular")
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        Divider()
                        
                        // Profile Information Section
                        VStack(alignment: .leading, spacing: 15) {
                            TextContent(
                                text: "Profil pengguna", size: 20, color: "ADADAD", transparency: 1.0,
                                weight: "regular")
                            
                            // Name TextField
                            HStack {
                                TextContent(
                                    text: "Nama", size: 15, color: "000000", transparency: 1.0,
                                    weight: "regular")
                                Spacer()
                                TextField("Ketik namamu", text: $name)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            // Gender Selection
                            HStack {
                                TextContent(
                                    text: "Jenis Kelamin", size: 15, color: "000000", transparency: 1.0,
                                    weight: "regular")
                                Spacer()
                                Picker("", selection: $gender) {
                                    Text("Laki-laki").tag(false)
                                    Text("Perempuan").tag(true)
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 500, height: 250)
                
                Spacer()
            }
        }
        .onAppear {
            checkPersonalVoice()
            gender = viewModel.userProfile.gender
            name = viewModel.userProfile.name
            sound = viewModel.userProfile.sound
        }
        .onChange(of: name) { newValue in
            viewModel.userProfile.name = newValue
        }
        .onChange(of: gender) { newValue in
            viewModel.userProfile.gender = newValue
            viewModel.updateProfile(name: name, gender: gender, sound: sound)
        }
        .onChange(of: sound) { newValue in
            viewModel.userProfile.sound = newValue
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        ) { _ in
            checkPersonalVoice()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Personal Voice Not Set"),
                message: Text("To set up Personal Voice, please go to Settings > Accessibility > Speech > Personal Voice."),
                primaryButton: .default(Text("Open Settings"), action: openSettings),
                secondaryButton: .cancel(Text("Cancel"), action: {
                    viewModel.userProfile.sound = false
                })
            )
        }
    }
    
    private func checkPersonalVoice() {
        Task {
            isPersonalVoiceAvailable = await viewModel.fetchPersonalVoices()
            if viewModel.userProfile.sound && !isPersonalVoiceAvailable {
                viewModel.userProfile.sound = false
                showAlert = true
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
