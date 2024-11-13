//
//  AddActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 10/11/24.
//


import SwiftUI
import UIKit

struct AddActivityView: View {
    @Environment(ActivityManager.self) private var activityManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(StateManager.self) private var stateManager
    
    @State private var stepDescription = ""
    @State private var showImagePicker = false
    @State private var tempImageURL: URL?
    @State private var activityName = ""
    @State private var navigateToAddStep = false
    @State private var showCamera = false
    @State private var isEditing = false // New State for Edit Mode
    var stepIndex: Int?
    @State private var selectedStepIndex: Int?
    var activityToEdit: Activity?
    
    init(activityToEdit: Activity? = nil, isEditing: Bool = false) {
           self.activityToEdit = activityToEdit
           self._isEditing = State(initialValue: isEditing) // Initialize isEditing from parameter
           _activityName = State(initialValue: activityToEdit?.name ?? "")
           _tempImageURL = State(initialValue: activityToEdit != nil ? URL(fileURLWithPath: activityToEdit!.image) : nil)
       }
    
    let viewPortWidth = UIScreen.main.bounds.width
    let viewPortHeight = UIScreen.main.bounds.height
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("Enter Activity Name", text: $activityName)
                    
                        .onChange(of: activityName) { newName in
                            activityManager.setName(name: newName)
                        }
                    
                    Button("Take Photo...") {
                        showCamera = true
                    }
                    
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, imageURL: $tempImageURL)
                            .onDisappear {
                                if let selectedURL = tempImageURL {
                                    activityManager.setImage(image: selectedURL.path)
                                }
                            }
                    }
                    
                    Button("Choose Activity Image...") {
                        showImagePicker = true
                    }
                    
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageURL: $tempImageURL)
                            .onDisappear {
                                if let selectedURL = tempImageURL {
                                    activityManager.setImage(image: selectedURL.path)
                                }
                            }
                    }
                    
                    if let imageURL = tempImageURL, let uiImage = UIImage(contentsOfFile: imageURL.path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .onDisappear{
                                tempImageURL = nil
                            }
                    }
                }
                
                
                
                Section(header: Text("Steps")) {
                    Button("Add Step") {
                        navigateToAddStep = true
                    }
                    .navigationDestination(isPresented: $navigateToAddStep) {
                        AddStepView()
                    }
                    
                    
                    ForEach(Array(getSteps().enumerated()), id: \.offset) { index, step in
                        VStack(alignment: .leading) {
                            if activityToEdit != nil || isEditing {
                                // Editable description
                                TextField("Step Description", text: Binding(
                                    get: { step.description },
                                    set: { newDescription in
                                        activityManager.updateStepDescription(description: newDescription, at: index)
                                    }
                                ))
                                
                                // Button to change image
                                Button("Change Step Image") {
                                    selectedStepIndex = index
                                    showImagePicker = true
                                }
                                .sheet(isPresented: $showImagePicker) {
                                    ImagePicker(imageURL: $tempImageURL)
                                        .onDisappear {
                                            if let selectedURL = tempImageURL {
                                                activityManager.setStepImage(image: selectedURL.path, at: index)
                                            }
                                        }
                                }
                                
                                // Show current image if available
                                if let uiImage = UIImage(contentsOfFile: step.image) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                } else {
                                    Text("Image not available")
                                }
                            } else {
                                // Non-editable step view
                                Text(step.description)
                                if let uiImage = UIImage(contentsOfFile: step.image) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    
                }
            }
            .navigationBarTitle(activityToEdit != nil ? "Edit Activity" : "Add New Activity", displayMode: .inline)
            .navigationBarItems(
                leading: Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                },
                trailing: Button(isEditing ? "Save" : "Done") {
                    saveOrUpdateActivity()
                    dismiss()
                }
            )
        }
        
    }
    
    private func getSteps() -> [Step] {
        return activityManager.activity.sequence
    }
    
    private func saveOrUpdateActivity() {
        guard !activityName.isEmpty else { return }
        
        if let activityToEdit = activityToEdit {
            let updatedActivity = Activity(
                id: activityToEdit.id,
                name: activityName,
                image: activityManager.activity.image,
                ruangan: Ruangan(id: UUID(), name: "Room 1"),
                sequence: activityManager.activity.sequence
            )
            activitiesManager.updateActivity(updatedActivity)
        } else {
            let newActivity = Activity(
                id: UUID(),
                name: activityName,
                image: activityManager.activity.image,
                ruangan: Ruangan(id: UUID(), name: "Room 1"),
                sequence: activityManager.activity.sequence
            )
            activitiesManager.addActivity(newActivity)
        }
        
        activityManager.resetSteps()
        dismiss()
    }
}


struct AddStepView: View {
    @Environment(ActivityManager.self) private var activityManager
    
    @State private var stepDescription = ""
    @State private var stepImageURL: URL?
    @State private var showImagePicker = false
    @Environment(\.dismiss) var dismiss
    
    var stepIndex: Int? // Pass this if you're editing an existing step
    
    @State private var showCamera = false
    
    var body: some View {
        Form {
            Section(header: Text("Step Details")) {
                TextField("Enter Step Description", text: $stepDescription)
                
                Button("Take Photo...") {
                    showCamera = true
                }
                .sheet(isPresented: $showCamera) {
                    ImagePicker(sourceType: .camera, imageURL: $stepImageURL)
                        .onDisappear {
                            if let selectedURL = stepImageURL {
                                if let index = stepIndex {
                                    activityManager.setStepImage(image: selectedURL.path, at: index)
                                } else {
                                    addStep(imageURL: selectedURL)
                                }
                            }
                        }
                }
                
                Button("Choose Step Image...") {
                    showImagePicker = true
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(imageURL: $stepImageURL)
                }
                
                if let imageURL = stepImageURL, let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                } else {
                    Text("")
                }
            }
            
            Section {
                Button(stepIndex == nil ? "Add Step" : "Update Step") {
                    saveStep(imageURL: stepImageURL)
                    stepDescription = ""
                    stepImageURL = nil
                }
            }
        }
        .onAppear {
            if let index = stepIndex {
                let step = activityManager.activity.sequence[index]
                stepDescription = step.description
                stepImageURL = URL(fileURLWithPath: step.image)
            }
        }
        .navigationBarTitle(stepIndex == nil ? "Add Step" : "Edit Step", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            saveStep(imageURL: stepImageURL)
            dismiss()
        })
    }
    
    private func saveStep(imageURL: URL?) {
        guard !stepDescription.isEmpty else { return }
        
        let step = Step(image: imageURL?.path ?? "", description: stepDescription)
        
        if let index = stepIndex {
            // Update existing step
            activityManager.updateStep(step, at: index)
        } else {
            // Add new step
            activityManager.addStep(step)
        }
    }
    
    private func addStep(imageURL: URL?) {
        guard !stepDescription.isEmpty else { return }
        
        let step = Step(image: stepImageURL?.path ?? "", description: stepDescription)
        
        activityManager.addStep(step)
    }
}





