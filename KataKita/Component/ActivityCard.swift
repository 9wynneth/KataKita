//
//  ActivityCard.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 09/10/24.
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    
    let width: CGFloat
    let height: CGFloat
    
    let number: String?
    let f: (() -> Void)?

    init(_ activity: Activity, size: (CGFloat, CGFloat) = (50, 50), number: String? = nil, f: (() -> Void)? = nil) {
        self.activity = activity
        self.number = number
        self.width = size.0
        self.height = size.1
        self.f = f
    }

    var body: some View {
        Button(action: {
            if let f = self.f {
                f()
            }
        }) {
            VStack {
                if let number = self.number {
                    HStack {
                        Text(LocalizedStringKey(number))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "000000", transparency: 1))
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 0))
                            
                        Spacer()
                    }
                    Spacer()
                }

                VStack(spacing: 4) {
                    if case let .image(data) = self.activity.type, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: self.width / 2, height: self.height / 2)
                    } else if case let .icon(icon) = self.activity.type {
                        Icon(icon, (self.width / 2, self.height / 2))
                    }

                    TextContent(
                        text: self.activity.name,
                        size: 14,
                        color: "000000",
                        transparency: 1,
                        weight: "medium"
                    )
                    .padding(2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                }
            }
            .frame(width: self.width, height: self.height)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StepCard: View {
    let step: Step
    
    let width: CGFloat
    let height: CGFloat
    
    let number: String?
    let f: (() -> Void)?

    init(_ step: Step, size: (CGFloat, CGFloat) = (50, 50), number: String? = nil, f: (() -> Void)? = nil) {
        self.step = step
        self.number = number
        self.width = size.0
        self.height = size.1
        self.f = f
    }

    var body: some View {
        Button(action: {
            if let f = self.f {
                f()
            }
        }) {
            VStack {
                if let number = self.number {
                    HStack {
                        Text(LocalizedStringKey(number))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "000000", transparency: 1))
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 0))
                            
                        Spacer()
                    }
                    Spacer()
                }

                VStack(spacing: 4) {
                    if case let .image(data) = self.step.type, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: self.width / 2, height: self.height / 2)
                    } else if case let .icon(icon) = self.step.type {
                        Icon(icon, (self.width / 2, self.height / 2))
                    }

                    TextContent(
                        text: self.step.description,
                        size: 14,
                        color: "000000",
                        transparency: 1,
                        weight: "medium"
                    )
                    .padding(2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                }
            }
            .padding(10)
            .frame(height: self.height)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
