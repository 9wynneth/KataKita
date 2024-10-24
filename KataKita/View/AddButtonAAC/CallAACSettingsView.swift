//
//  CallAACSettingsView.swift
//  KataKita
//
//  Created by Aqilla Shahbani Mahazoya on 15/10/24.
//

import SwiftUI

struct CallAACSettingsView: View {
    @State private var showAACSettings = false
    
    
    @State static var navigateTooAddImage = true
    @State static var selectedSymbolImage = "star.fill"
    @State static var navigateFromSymbols = false
    @State static var navigateFromImage = false
    @State static var selectedSymbolName = ""
    
    var body: some View {
        Button("Choose Image...") {
            showAACSettings = true
        }
//        .sheet(isPresented: $showAACSettings) {
//            AddButtonAACView(
//                navigateTooAddImage: CallAACSettingsView.$navigateTooAddImage,
//                selectedSymbolImage: CallAACSettingsView.$selectedSymbolImage,
//                navigateFromSymbols: CallAACSettingsView.$navigateFromSymbols,
//                navigateFromImage: CallAACSettingsView.$navigateFromImage,
//                selectedSymbolName: CallAACSettingsView.$selectedSymbolName,
//                selectedImage: .constant(nil)
//            )
//        }
    }
}

#Preview {
    CallAACSettingsView()
}
