//
//  AddNewActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 13/11/24.
//

import SwiftUI

struct AddNewActivityView: View {
    
    @Environment(ActivityManager.self) private var activityManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(StateManager.self) private var stateManager

    
    @State private var stepDescription = ""
    @State private var showImagePicker = false
    @State private var tempImageURL: URL?
    @State private var activityName = ""
    @State private var navigateToAddStep = false
    @State private var showCamera = false
    var stepIndex: Int?
    @State private var selectedStepIndex: Int?
    var activityToEdit: Activity?
    @State var isEditing: Bool = false
    var body: some View {
        NavigationView{
            Form { 
                Section(header: Text("DETAIL AKTIVITAS")) {
                    TextField("Enter Activity Name", text: $activityName)
                        .onChange(of: activityName) { newName in
                            activityManager.setName(name: newName)
                        }
                        .foregroundColor(Color.black)
                    
                }
            }
            .background(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Color(hex: "BDD4CE", transparency: 1.0))
            )
            .foregroundColor(.white)
            .navigationTitle("adfa")
            .navigationBarTitleDisplayMode(.inline)
        }
        .foregroundColor(.white)
        .scrollContentBackground(.hidden)
       
        
    }
}

#Preview {
    AddNewActivityView()
}
