//
//  CustomButton.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//
import SwiftUI

struct CustomButtonSearch: View {
    let icon: String?
    let text: String?
    let font: Int
    let width: CGFloat
    let height: CGFloat
    let iconWidth: Int?
    let iconHeight: Int?
    let bgColor: String
    let bgTransparency: Double
    let fontColor: String
    let fontTransparency: Double
    let cornerRadius: CGFloat
    let strokeColor: String?
    let isSystemImage: Bool
    let action: (() -> Void)?
    
    init(icon: String? = nil, text: String? = nil, width: CGFloat, height: CGFloat, font: Int, iconWidth: Int? = nil, iconHeight: Int? = nil, bgColor: String, bgTransparency: Double, fontColor: String, fontTransparency: Double, cornerRadius: CGFloat, strokeColor: String? = nil, isSystemImage: Bool = true, action: (() -> Void)? = nil) {
        self.icon = icon
        self.text = text
        self.width = width
        self.height = height
        self.font = font
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        self.bgColor = bgColor
        self.bgTransparency = bgTransparency
        self.fontColor = fontColor
        self.fontTransparency = fontTransparency
        self.cornerRadius = cornerRadius
        self.strokeColor = strokeColor
        self.isSystemImage = isSystemImage
        self.action = action
    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        Button {
            if let action {
                action()
            }
        } label: {
            VStack(spacing: 0) {
                Spacer()
                
                if let icon = icon, !icon.isEmpty {
                    let localizedIcon = NSLocalizedString(icon, comment: "") // Localize the icon name
                    let iconbaru = localizedIcon
  
                    Image(iconbaru.uppercased()) // Use the localized name here
                        .antialiased(true)
                        .resizable()
                        .scaledToFit()
                        .frame(width: CGFloat(iconWidth ?? 24), height: CGFloat(iconHeight ?? 24))
                        .foregroundColor(Color(hex: fontColor, transparency: fontTransparency))
                        .onAppear() {
                            print("coba cek icon sebelum \(icon)" + "coba cek icon sesudah \(localizedIcon)" + "coba cek icon sesudah \(iconbaru)")
                        }
                }
                
                if let text = text, !text.isEmpty {
                    TextContentBoard(
                        text: text,
                        size: Int(CGFloat(font)),
                        color: fontColor,
                        transparency: fontTransparency,
                        weight: "medium"
                    )
                    .padding(.horizontal)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .minimumScaleFactor(0.3)
                    .allowsTightening(true)
                }
                
                Spacer()
            }
            .onAppear(){
                print("coba cek icon" + String(icon ?? ""))
            }
            .frame(width: CGFloat(width), height: CGFloat(height))
            .background(Color(hex: bgColor, transparency: bgTransparency))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                Group {
                    if let strokeColor = strokeColor {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color(hex: strokeColor, transparency: 1.0), lineWidth: 1)
                    } else {
                        EmptyView()
                    }
                }
            )
            .shadow(color: Color(hex: "000000", transparency: 0.1), radius:10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Text only
#Preview {
    CustomButton(text: "Text Only", width: 150, height: 50, font: 14, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20) {
        print("TEST")
    }
}

// Icon only
#Preview {
    CustomButton(icon: "star.fill", width: 100, height: 100, font: 50,iconWidth: 50, iconHeight: 50, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20)
}

// Image only
#Preview {
    CustomButton(icon: "ball", width: 100, height: 100, font: 40, iconWidth: 50, iconHeight: 50, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20, isSystemImage: false)
}

// Icon and text
#Preview {
    CustomButton(icon: "star.fill", text: "Star", width: 150, height: 50, font: 24, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20)
}

// Image and text
#Preview {
    CustomButton(icon: "ball", text: "Custom", width: 153, height: 153, font: 24, iconWidth: 80, iconHeight: 60, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20, isSystemImage: false)
}


