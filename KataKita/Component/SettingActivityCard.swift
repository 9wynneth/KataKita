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
    let delete: (() -> Void)?
    init(_ activity: Activity, number: Int? = nil, delete: (() -> Void)? = nil) {
        self.activity = activity
        self.number = number
        self.delete = delete
    }
    var body: some View {
        HStack (spacing: 20){
            if let number {
                Circle()
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 25, height: 25)
                    .overlay(
                        Text("\(number)")
                    )
            }
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(number != nil ? Color(hex: "F7F5F0", transparency: 1.0): Color(hex: "BDD4CE", transparency: 1.0))
                    .frame(width: 70, height: 70)
                   
                    .overlay {
                        if let uiImage = UIImage(contentsOfFile: activity.image) {
                            Image(uiImage: uiImage)  // Use Image from UIImage
                                .resizable()
                                .frame(width: 55, height: 55)
                        } else {
                            Image(activity.image)
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                    }
                                       
                
                TextContent(
                    text: "\(activity.name)",
                    size: 25,
                    color: "313131",
                    weight: "Light")
                
            }
            Spacer()
            if(number != nil) {
                Button {
                    if let delete {
                        delete()
                    }
                } label: {
                    Circle()
                        .fill(Color(hex: "EB7D7B", transparency: 1))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "minus").foregroundStyle(.white)
                        )
                }
            }
            else {
                Image(systemName: "plus")
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


