////
////  DraggableButton.swift
////  KataKita
////
////  Created by Gwynneth Isviandhy on 01/11/24.
////
//
//import SwiftUI
//
//struct DraggableButton: View {
//    let card: Card
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    @State private var position = CGSize.zero
//    @State private var dragOffset = CGSize.zero
//    @State private var originalPosition = CGSize.zero
//    
//    var body: some View {
//        CustomButton(
//            icon: resolveIcon(for: card.icon),
//            text: card.name,
//            width: Int(screenWidth * (100 / 1376.0)),
//            height: Int(screenHeight * (100 / 1032.0)),
//            font: Int(screenWidth * (35 / 1376.0)),
//            iconWidth: Int(screenWidth * (80 / 1376.0)),
//            iconHeight: Int(screenHeight * (80 / 1032.0)),
//            bgColor: card.category.color,
//            bgTransparency: 0.7,
//            fontColor: card.category.fontColor,
//            fontTransparency: 1.0,
//            cornerRadius: 10,
//            isSystemImage: false
//        )
//        .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    dragOffset = value.translation // Update drag offset
//                }
//                .onEnded { value in
//                    // Check the drop location against the red rectangle and the rounded rectangle
//                    let dropLocation = value.location
//                    let rectangleBounds = CGRect(
//                        x: (screenWidth - 20) / 2, // Adjust this based on your layout
//                        y: 0,
//                        width: 20,
//                        height: 500
//                    )
//                    
//                    // Define bounds for the rounded rectangle in the HStack
//                    let roundedRectBounds = CGRect(
//                        x: (screenWidth - 900) / 2, // Adjust based on the HStack's position
//                        y: screenHeight * (700 / 1024.0), // Adjust based on its position
//                        width: 900,
//                        height: 100
//                    )
//                    
//                    if rectangleBounds.contains(dropLocation) || roundedRectBounds.contains(dropLocation) {
//                        // Update the button's position if dropped inside the allowed areas
//                        position.width += dragOffset.width
//                        position.height += dragOffset.height
//                    } else {
//                        // Reset the position if dropped outside the allowed areas
//                        resetPosition()
//                    }
//                    dragOffset = .zero // Reset drag offset
//                }
//        )
//        .onAppear {
//            // Store the original position when the view appears
//            originalPosition = position
//        }    }
//    
//    private func isDropInsideVStack(_ dropLocation: CGPoint) -> Bool {
//            // Check if the drop location is within the bounds of the VStack
//            let vStackFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 500) // Adjust the size as needed
//            return vStackFrame.contains(dropLocation)
//        }
//        
//        private func resetPosition() {
//            // Reset the button's position to the original position
//            position = originalPosition
//        }
//}
//
////#Preview {
////    DraggableButton(card: <#Card#>)
////}
