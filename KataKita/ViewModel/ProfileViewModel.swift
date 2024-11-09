import SwiftUI

@Observable
class ProfileViewModel {
    var userProfile = UserProfile()
    
    func updateProfile(name: String, gender: Bool, sound: Bool) {
        userProfile.name = name
        userProfile.gender = gender
        userProfile.sound = sound
        
        guard let data = try? JSONEncoder().encode(userProfile) else {
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "user")
    }
    
    func fetchPersonalVoices() async -> Bool {
        return false
    }
}

struct UserProfile: Codable {
    var name: String = ""
    var gender: Bool = false // false for Laki-laki, true for Perempuan
    var sound: Bool = false
}
