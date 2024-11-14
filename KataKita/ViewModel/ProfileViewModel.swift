import SwiftUI

@Observable
class ProfileViewModel {
    var userProfile = UserProfile()
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let raw = defaults.object(forKey: "user") as? Data {
            guard let user = try? JSONDecoder().decode(UserProfile.self, from: raw) else {
                return
            }
            self.userProfile = user
        } else {
            self.userProfile = UserProfile()
        }
    }
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
