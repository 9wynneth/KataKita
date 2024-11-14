//
//  TextContent.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 15/10/24.
//

import SwiftUI

struct TextContentSearch: View {
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
        if Locale.current.language.languageCode?.identifier == "en" {
            if AllAssets.shared.genderAssets.contains(text.lowercased())
            {
                let styledText: Text = Text(((text).lowercased()))
                    .font(Font.custom("MADECarvingSoftPERSONALUSE-\(mapFontWeight(weight))", size: CGFloat(size)))
                    .foregroundColor(Color(hex: color, transparency: transparency))
                
                return styledText
            }
            else {
                let styledText: Text = Text((text).lowercased())
                    .font(Font.custom("MADECarvingSoftPERSONALUSE-\(mapFontWeight(weight))", size: CGFloat(size)))
                    .foregroundColor(Color(hex: color, transparency: transparency))
                
                return styledText
            }
        }
        else
        {
            let styledText: Text = Text((text).lowercased())
                .font(Font.custom("MADECarvingSoftPERSONALUSE-\(mapFontWeight(weight))", size: CGFloat(size)))
                .foregroundColor(Color(hex: color, transparency: transparency))
            
            return styledText
            
        }
    }
   
    
    func mapFontWeight(_ weight: String) -> String {
        switch weight.lowercased() {
        case "extralight": return "ExtraLight"
        case "thin": return "Thin"
        case "light": return "Light"
        case "regular": return "Regular"
        case "medium": return "Medium"
        case "semibold": return "SemiBold"
        case "bold": return "Bold"
        case "black": return "Black"
        default: return "Regular"
        }
    }

}

// heading
#Preview {
    TextContent(text: "Styled Text", size: 196, color: "00000", transparency: 1.0, weight: "thin")
}
