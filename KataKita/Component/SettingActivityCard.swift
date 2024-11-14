//
//  CustomActivityCard.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 13/10/24.
//

import SwiftUI

struct SettingActivityCard: View {
    let activity: Activity
    let number: Int?
    let add: (() -> Void)?
    let delete: (() -> Void)?
    let edit: (() -> Void)?

    init(_ activity: Activity, number: Int? = nil, add: (() -> Void)? = nil, delete: (() -> Void)? = nil, edit: (() -> Void)? = nil) {
        self.activity = activity
        self.number = number
        self.add = add
        self.delete = delete
        self.edit = edit
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if let number = self.number {
                Circle()
                    .stroke(
                        Color.black,
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 25, height: 25)
                    .overlay(
                        Text("\(number)")
                    )
            }
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        self.number != nil
                            ? Color(hex: "F7F5F0", transparency: 1.0)
                            : Color(hex: "BDD4CE", transparency: 1.0)
                    )
                    .frame(width: 70, height: 70)
                    .overlay {
                        Group {
                            if case let .image(data) = self.activity.type {
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)  // Use Image from UIImage
                                        .resizable()
                                        .frame(width: 55, height: 55)
                                }
                            } else if case let .icon(icon) = self.activity.type {
                                Icon(icon, (55, 55))
                            } else {
                                Color.clear.frame(width: 55, height: 55)
                            }
                        }
                    }
                
                TextContent(
                    text: "\(activity.name)",
                    size: 25,
                    color: "313131",
                    weight: "Light"
                )
            }
            
            Spacer()
            
            if let f = self.delete {
                Button {
                    f()
                } label: {
                    Circle()
                        .fill(Color(hex: "EB7D7B", transparency: 1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "trash").foregroundStyle(.white)
                        )
                }
            }
            if let f = self.edit {
                Button {
                    f()
                } label: {
                    Circle()
                        .fill(Color(hex: "EB7D7B", transparency: 0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "pencil").foregroundStyle(.black)
                        )
                }
            }
            if let f = self.add {
                Button {
                    f()
                } label: {
                    Circle()
                        .fill(Color(hex: "EB7D7B", transparency: 0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "plus").foregroundStyle(.black)
                        )
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .fill(.tertiary)
                    .frame(height: 1)
            }
        )
    }
}
