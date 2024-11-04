////
////  PecsLessonView.swift
////  KataKita
////
////  Created by Gwynneth Isviandhy on 31/10/24.
////
//
//import SwiftUI
//
//struct PecsLessonView: View {
//    //    var selectedLessons: [Card]
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var lessonViewModel: LessonViewModel
//    let screenWidth = UIScreen.main.bounds.width
//    let screenHeight = UIScreen.main.bounds.height
//    
//    let templateWidth = 1366.0
//    let templateHeight = 1024.0
//    
//    @State private var position = CGSize.zero
//    @State private var scale: CGFloat = 1.0 // State to track scale for pinch gesture
////    @State private var dragAmount: CGPoint?
//    @State private var dragAmounts: [UUID: CGPoint] = [:] // Dictionary for each card's drag amount
//
//    
//    var body: some View {
//        VStack {
//            HStack (spacing:20) {
//                Spacer()
//                // left side
//                VStack (spacing:30) {
//                    
//                    //whiteboard
//                    VStack {
//                        HStack {
//                            ForEach(0..<5, id: \.self) { _ in
//                                //rectangle
//                                VStack (spacing: 5) {
//                                    ForEach(lessonViewModel.selectedCardLesson, id: \.id) { card in
//                                        DraggableButton(card: card)
//
//                                        
//                                    }
//                                }
//                                .background(
//                                        Rectangle()
//                                            .fill(Color.red)
//                                            .frame(width: 20, height: 500)
//                                            
//                                )
//                                .padding(.trailing, 50)
//                                .padding(.leading, 50)
//                            }
//                        }
//                        .frame(width: screenWidth * (1029 / templateWidth), height: screenHeight * (700 / templateHeight))
//
//                    }
//                    .frame(width: screenWidth * (1029 / templateWidth), height: screenHeight * (700 / templateHeight))
//                    .background(
//                        RoundedRectangle(cornerRadius: 30)
//                            .fill(Color(hex: "F7F5F0", transparency: 1.0))
//                    )
//
//                    
//                    //textbox
//                    HStack(spacing:15) {
//                        HStack {
//                            
//                        }
//                        .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color(hex: "F7F5F0", transparency: 1.0))
//                            .frame(width: 900, height: 100))
//                        VStack {
//                            CustomButton(
//                                icon: "trash",
//                                width: 100,
//                                height: 100,
//                                font: 60,
//                                iconWidth: 50,
//                                iconHeight: 50,
//                                bgColor: "#F7F5F0",
//                                bgTransparency: 1.0,
//                                fontColor: "#696767",
//                                fontTransparency: 1.0,
//                                cornerRadius: 20
//                            )
//                        }
//                        
//                    }
//                    .frame(width: 1029)
//                    
//                    Spacer()
//                }
//                .padding(.top,50)
//                .padding()
//                
//                
//                // 2 buttons
//                VStack {
//                    CustomButton(
//                        icon: "arrowshape.turn.up.backward.fill",
//                        width: 80,
//                        height: 80,
//                        font: 40,
//                        iconWidth: 40,
//                        iconHeight: 40,
//                        bgColor: "F7F5F0",
//                        bgTransparency: 1.0,
//                        fontColor: "696767",
//                        fontTransparency: 1.0,
//                        cornerRadius: 20,
//                        action: {
//                            dismiss()
//                        }
//                        
//                    )
//                    
//                    
//                    CustomButton(
//                        icon: "gearshape.fill",
//                        width: 80,
//                        height: 80,
//                        font: 40,
//                        iconWidth: 40,
//                        iconHeight: 40,
//                        bgColor: "F7F5F0",
//                        bgTransparency: 1.0,
//                        fontColor: "696767",
//                        fontTransparency: 1.0,
//                        cornerRadius: 20
//                    )
//                    Spacer()
//                }
//                .padding(.top,60)
//                
//                
//                Spacer()
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(hex: "BDD4CE", transparency: 1.0))
//        .edgesIgnoringSafeArea(.all)
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//extension LessonViewModel {
//    var groupedByCategory: [Category: [Card]] {
//        Dictionary(grouping: selectedCardLesson, by: { $0.category })
//    }
//}
//
////#Preview {
////    PecsLessonView()
////}
