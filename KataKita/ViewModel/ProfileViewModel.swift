import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    
    init() {
        loadProfile()
    }
    
    func updateProfile(name: String, gender: Bool) {
        userProfile.name = name
        userProfile.gender = gender
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
}

struct UserProfile {
    var name: String = ""
    var gender: Bool = false // false for Laki-laki, true for Perempuan
}
