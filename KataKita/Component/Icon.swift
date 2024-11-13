//
//  Icon.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 13/11/24.
//

import SwiftUI

struct Icon: View {
    @Environment(ProfileViewModel.self) private var viewModel
    
    let icon: String
    let width: CGFloat
    let height: CGFloat
    
    init(_ icon: String, _ size: (CGFloat, CGFloat) = (50, 50)) {
        self.icon = icon
        self.width = size.0
        self.height = size.1
    }
    
    var body: some View {
        Image(self.resolveIcon("\(self.genderHandler(self.icon))\(self.icon)"))
            .antialiased(true)
            .resizable()
            .scaledToFit()
            .frame(width: self.width, height: self.height)
    }
    
    private func resolveIcon(_ icon: String) -> String {
        if let _ = UIImage(named: icon) {
            return icon
        } else if let _ = UIImage(named: icon.uppercased()) {
            return icon.uppercased()
        } else if let _ = UIImage(named: icon.lowercased()) {
            return icon.lowercased()
        } else {
            // Fallback option if no icon is found
            return "defaultIcon" // You can define a default icon
        }
    }
    
    private func genderHandler(_ name: String) -> String {
        if AllAssets.shared.genderAssets.contains(name) {
            if self.viewModel.userProfile.gender {
                return "GIRL_"
            }
            return "BOY_"
        }
        return ""
    }
}
