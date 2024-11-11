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
    var fontColor: String
    var fontTransparency: Double
    var cornerRadius: CGFloat
    let action: (() -> Void)?

    var body: some View {
        Button {
            if let action {
                action()
            }
        } label: {
            VStack(spacing: 0) { // Reduced spacing between Image and Text
                Image(uiImage: (UIImage(named: icon) ?? UIImage()))
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconWidth, height: iconHeight)
                    .cornerRadius(cornerRadius)
                
                TextContent(
                    text: text,
                    size: Int(font),
                    color: fontColor,
                    transparency: fontTransparency,
                    weight: "medium"
                )
            }
            .frame(width: width, height: height)
            .background(bgColor.opacity(bgTransparency))
            .cornerRadius(cornerRadius)
        }
    }
}
