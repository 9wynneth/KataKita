import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    
    init() {
        loadProfile()
    }
    
    func updateProfile(name: String, gender: Bool, sound: Bool) {
        userProfile.name = name
        userProfile.gender = gender
        userProfile.sound = sound
        saveProfile()
    }
    
    private func saveProfile() {
        UserDefaults.standard.set(userProfile.name, forKey: "userName")
        UserDefaults.standard.set(userProfile.gender, forKey: "userGender")
    }
    
    private func loadProfile() {
        userProfile.name = UserDefaults.standard.string(forKey: "userName") ?? ""
        userProfile.gender = UserDefaults.standard.bool(forKey: "userGender")
    }
    
    func fetchPersonalVoices() async -> Bool {
        return false
    }
}

struct UserProfile {
    var name: String = ""
    var gender: Bool = false // false for Laki-laki, true for Perempuan
    var sound: Bool = false
}
