import SwiftUI

struct SettingsView: View {
    //MARK: Viewport size
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @Binding var selectedVoice: VoiceOption

   
    var body: some View {
        VStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text("PROFIL PENGGUNA")) {
                    HStack {
                        Text("testsubject@icloud.com")
                        Spacer()
                        
                        HStack
                        {
                            Text("Detail")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Text("Warna Kulit")
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
//                        NavigationLink(destination: DetailView()) {
//
//                        }
                    }
                    HStack {
                        Text("Bahasa")
                        Spacer()
//                        NavigationLink(destination: DetailView()) {
//                            Text("Detail")
//                                .foregroundColor(.gray)
//                        }
                        HStack
                        {
                            Text("Detail")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                        }
                    }
                }
                
                // Pengaturan Kataloka Section
                Section(header: Text("PENGATURAN KATALOKA")) {
                    HStack {
                        Text("Pengaturan Aktivitas Harian")
                        Spacer()
                        NavigationLink(destination: AddDailyActivityView()) {
                            HStack{
                                Spacer()
                                
                                Text("Detail")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                    
                    HStack {
                        Text("Pengaturan Urutan Aktifitas")
                        Spacer()
//                        NavigationLink(destination: DetailView()) {
//                            Text("Detail")
//                                .foregroundColor(.gray)
//                        }
                        HStack
                        {
                            Text("Detail")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Voice Settings")) {
                                Picker("Select Voice", selection: $selectedVoice) {
                                    Text("Girl").tag(VoiceOption.girl)
                                    Text("Boy").tag(VoiceOption.boy)
                                    Text("Personalized").tag(VoiceOption.personalized)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
            }
            .frame(width: screenWidth * 0.5)
            .onAppear{
                print("setting muncul")
            }
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail Page")
    }
}

#Preview {
    SettingsView()
}
