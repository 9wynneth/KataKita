//
//  TextHeadlineOne.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//

import SwiftUI

struct TextHeadline: View {
    let text: String
    let size: Int
    let color: String
    let transparency: Double
    let weight: String
    
    init(text: String, size:Int, color: String, transparency: Double = 1.0, weight: String) {
        self.text = text
        self.size = size
        self.color = color
        self.transparency = transparency
        self.weight = weight
    }
    
    var body: some View {
            var styledText: Text = Text(LocalizedStringKey(text))
            .font(Font.custom("agency", size: CGFloat(size)))
                .foregroundColor(Color(hex: color, transparency: transparency))
                .fontWeight(mapFontWeight(weight))

            return styledText
        }
        
        func mapFontWeight(_ weight: String) -> Font.Weight {
            switch weight.lowercased() {
            case "ultralight": return .ultraLight
            case "thin": return .thin
            case "light": return .light
            case "regular": return .regular
            case "medium": return .medium
            case "semibold": return .semibold
            case "bold": return .bold
            case "heavy": return .heavy
            case "black": return .black
            default: return .regular
            }
        }
}

// heading
#Preview {
    TextHeadline(text: "Styled Text", size: 196, color: "00000", transparency: 1.0, weight: "bold")
}
