//
//  SecurityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

struct SecurityView: View {
    @State private var randomFourDigitNumber = generateUniqueFourDigitNumber()
    @State private var currentDigitIndex = 0
    @State private var buttonColors: [String] = Array(repeating: "#F7F5F0", count: 10) // Button colors for 0-9
    
//    @State var isCorrect: Bool = false
    @Environment(SecurityManager.self) private var securityManager

    
    // Separate digits of the random number
    var codeDigits: [Int] {
        return String(randomFourDigitNumber).compactMap { Int(String($0)) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Enter \(String(format: "%d", randomFourDigitNumber))")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 3)

            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(1...3, id: \.self) { col in
                            let number = row * 3 + col
                            CustomButtonSide(
                                icon: "",
                                text: "\(number)",
                                width: 80,
                                height: 80,
                                font: 60,
                                bgColor: buttonColors[number],
                                bgTransparency: 1.0,
                                fontColor: "#000000",
                                fontTransparency: 1.0,
                                cornerRadius: 20,
                                action: {
                                    handleButtonPress(number: number)
                                }
                            )
                            .onTapGesture {
                                handleButtonPress(number: number)
                            }
                        }
                    }
                }
                
                HStack {
                    CustomButtonSide(
                        icon: "",
                        text: "0",
                        width: 80,
                        height: 80,
                        font: 60,
                        bgColor: buttonColors[0],
                        bgTransparency: 1.0,
                        fontColor: "#000000",
                        fontTransparency: 1.0,
                        cornerRadius: 20,
                        action: {
                            handleButtonPress(number: 0)

                        }
                    )
                    .onTapGesture {
                        handleButtonPress(number: 0)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 420)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(hex: "BDD4CE", transparency: 1.0))
        )

    }
    
    // Function to handle button presses
    func handleButtonPress(number: Int) {
        guard currentDigitIndex < codeDigits.count else { return }
        
        if number == codeDigits[currentDigitIndex] {
            // Correct button pressed
            buttonColors[number] = "BDD4CE"  // Change color to red for correct press
            currentDigitIndex += 1
            
            // Check if the full code has been entered
            if currentDigitIndex == codeDigits.count {
                securityManager.isCorrect = true
            }
        } else {
            // Incorrect button pressed - reset input
            resetInput()
        }
    }
    
    // Function to reset input and button colors
    func resetInput() {
        currentDigitIndex = 0
        buttonColors = Array(repeating: "#F7F5F0", count: 10)
    }
    
    

}

func generateUniqueFourDigitNumber() -> Int {
    var digits = Array(0...9)
    digits.shuffle()
    
    // Ensure the first digit is not zero
    if digits[0] == 0 {
        digits.swapAt(0, 1)
    }
    
    let number = digits[0...3].reduce(0) { $0 * 10 + $1 }
    return number
}

#Preview {
    SecurityView()
}
