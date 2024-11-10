//
//  ActivityCard.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//

import SwiftUI

struct ActivityCard: View {
    let icon: String?
    let nomor: String
    let text: String?
    let font: Int
    let width: Int
    let height: Int
    let iconWidth: Int?
    let iconHeight: Int?
    let bgColor: String
    let bgTransparency: Double
    let fontColor: String
    let fontTransparency: Double
    let cornerRadius: CGFloat
    let isSystemImage: Bool
    let action: (() -> Void)?

    init(icon: String? = nil,nomor: String, text: String? = nil, width: Int, height: Int, font: Int, iconWidth: Int? = nil, iconHeight: Int? = nil, bgColor: String, bgTransparency: Double, fontColor: String, fontTransparency: Double, cornerRadius: CGFloat, isSystemImage: Bool = true, action: (() -> Void)? = nil) {
        self.icon = icon
        self.nomor = nomor
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
        self.isSystemImage = isSystemImage
        self.action = action
    }

    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack {
                HStack {
                    Text(nomor)
                        .font(.system(size: CGFloat(font), weight: .medium))
                        .foregroundColor(Color(hex: fontColor, transparency: fontTransparency))
                        .padding(.leading,8)
                        .padding(.top,8)
                        
                    Spacer()
                }
                Spacer()
                VStack(spacing: 4) {
                    Spacer()
                    if let icon = icon, !icon.isEmpty {
                        if isSystemImage {
                            // If it's a system image, use the systemName initializer
                            Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: CGFloat(iconWidth ?? 24), height: CGFloat(iconHeight ?? 24))
                                .foregroundColor(Color(hex: fontColor, transparency: fontTransparency))
                                .padding(.trailing, 8)
                        } else {
                            // First, attempt to load the image from a file path
                            if let uiImage = UIImage(contentsOfFile: icon) {
                                Image(uiImage: uiImage)  // Use the loaded UIImage if it's a valid file path
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: CGFloat(iconWidth ?? 24), height: CGFloat(iconHeight ?? 24))
                                    .padding(.trailing, 8)
                            } else {
                                // If the file path is invalid or it's actually an asset image, load from assets
                                Image(icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: CGFloat(iconWidth ?? 24), height: CGFloat(iconHeight ?? 24))
                                    .padding(.trailing, 8)
                            }
                        }
                    }


                    
                    if let text = text, !text.isEmpty {
                        TextContent(
                            text: text,
                            size: Int(CGFloat(font)),
                            color: fontColor,
                            transparency: fontTransparency,
                            weight: "medium"
                        )
                        .padding(2)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)  
                        .allowsTightening(true)
   
                    }
                    
                    Spacer()
                }.padding(.top,-15)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: CGFloat(width), height: CGFloat(height))
        .background(Color(hex: bgColor, transparency: bgTransparency))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: Color(hex: "000000", transparency: 0.1), radius:10)

    }
}

// if it's image set isSystemImage to false , but if it's sfsymbols set it to true
#Preview {
    ActivityCard(icon: "ball", nomor: "1", text: "Ambil sikat gigimu dan taru di dalam", width: 260, height: 150, font: 15, iconWidth: 50, iconHeight: 50, bgColor: "#000000", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 20, isSystemImage: false)
}
