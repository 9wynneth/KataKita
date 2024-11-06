import SwiftUI

struct CustomIcon: View {
    var icon: String
    var text: String
    var width: CGFloat
    var height: CGFloat
    var font: CGFloat
    var iconWidth: CGFloat
    var iconHeight: CGFloat
    var bgColor: Color
    var bgTransparency: Double
    var fontColor: Color
    var fontTransparency: Double
    var cornerRadius: CGFloat

    var body: some View {
        VStack(spacing: 4) { // Reduced spacing between Image and Text
            Image(uiImage: (UIImage(named: icon) ?? UIImage()))
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth, height: iconHeight)
                .cornerRadius(cornerRadius)

            Text(text)
                .font(.system(size: font))
                .foregroundColor(fontColor.opacity(fontTransparency))
        }
        .frame(width: width, height: height)
        .background(bgColor.opacity(bgTransparency))
        .cornerRadius(cornerRadius)
    }
}
