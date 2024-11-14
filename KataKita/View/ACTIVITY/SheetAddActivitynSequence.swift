//
//  AddActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 10/11/24.
//

import SwiftUI
import UIKit


struct AddActivityView: View {
    // @Environment(ActivityManager.self) private var activityManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    
    @State private var activityManager = ActivityManager()

    @State private var stepDescription = ""
    @State private var showImagePicker = false
    @State private var showStepImagePicker = false // Separate state for step image picker
    @State private var activityName = ""
    @State private var navigateToAddStep = false
    @State private var showCamera = false
    @State var isEditing: Bool = false
    
    @Binding var activityToEdit: Activity?
    @Binding var editUlang: Bool
    
    @State private var tempImage: Data? // Used only for activity image
    @State private var tempStepImage: Data? // Separate for step images
    @State private var selectedStepIndex: Int?
    
    let viewPortWidth = UIScreen.main.bounds.width
    let viewPortHeight = UIScreen.main.bounds.height
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: ActivityType.image Picker
                Section(header: Text("Activity Details")) {
                    TextField("Enter Activity Name", text: self.$activityName)
                    
                    Button("Take Photo...") {
                        self.showCamera = true
                    }
                    .sheet(isPresented: self.$showCamera) {
                        ImagePicker(self.$tempImage, .camera)
                            .onDisappear {
                                if let data = self.tempImage {
                                    self.activityManager.setType(.image(data))
                                }
                            }
                    }
                    
                    Button("Choose Activity Image...") {
                        self.showImagePicker = true
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        ImagePicker(self.$tempImage)
                            .onDisappear {
                                if let data = self.tempImage {
                                    self.activityManager.setType(.image(data))
                                }
                            }
                    }
                    
                    if let data = self.tempImage, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                    }
                }
                
                // MARK: Sequence
                Section(header: Text("Steps")) {
                    Button("Add Step") {
                        self.navigateToAddStep = true
                    }
                    
                    ForEach(Array(self.getSteps().enumerated()), id: \.offset) { index, step in
                        VStack(alignment: .leading) {
                            if self.activityToEdit != nil || self.editUlang {
                                TextField("Step Description", text: Binding(
                                    get: { step.description },
                                    set: { newDescription in
                                        self.activityManager.setStepDescription(description: newDescription, at: index)
                                    }
                                ))
                                
                                Button("Change Step Image") {
                                    self.selectedStepIndex = index
                                    self.showStepImagePicker = true
                                }
                                .sheet(isPresented: self.$showStepImagePicker) {
                                    ImagePicker(self.$tempStepImage) // Use tempStepImageURL here
                                        .onDisappear {
                                            if let data = self.tempStepImage, let index = self.selectedStepIndex {
                                                self.activityManager.setStepType(.image(data), at: index)
                                                self.tempStepImage = nil // Clear after use
                                                self.selectedStepIndex = nil
                                            }
                                        }
                                }
                                
                                if case let .image(data) = step.type {
                                    if let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(20)
                                    }
                                } else if case let .icon(icon) = step.type {
                                    Icon(icon, (100, 100))
                                } else {
                                    Text("Image not available")
                                }
                            } else {
                                Text(step.description)
                                
                                if case let .image(data) = step.type {
                                    if let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(20)
                                    }
                                } else if case let .icon(icon) = step.type {
                                    Icon(icon, (100, 100))
                                } else {
                                    Text("Image not available")
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationDestination(isPresented: self.$navigateToAddStep) {
                AddStepView(self.$activityManager)
            }
            .navigationBarTitle(self.activityToEdit != nil ? "Edit Activity" : "Add New Activity", displayMode: .inline)
            .navigationBarItems(
                leading: Button(self.isEditing ? "Cancel" : "Edit") {
                    self.isEditing.toggle()
                },
                trailing: Button(self.isEditing ? "Save" : "Done") {
                    self.isEditing = false
                    self.saveOrUpdateActivity()
                    self.dismiss()
                }
            )
        }
        .onChange(of: self.activityName) {
            self.activityManager.setName(self.activityName)
        }
        .onAppear {
            if let activity = self.activityToEdit {
                self.activityManager.activity = activity
                self.activityName = activity.name
                if case let .image(data) = activity.type {
                    self.tempImage = data
                }
            }
        }
        .onDisappear {
            self.activityManager.activity = Activity(name: "new activity", sequence: [])
        }
    }
    
    private func getSteps() -> [Step] {
        return activityManager.activity.sequence
    }
    
    private func saveOrUpdateActivity() {
        guard !activityName.isEmpty else { return }
        
        if let activityToEdit = self.activityToEdit {
            activityToEdit.name = self.activityName
            activityToEdit.type = self.activityManager.activity.type
            activityToEdit.sequence = self.activityManager.activity.sequence
            self.activitiesManager.updateActivity(activityToEdit)
        } else {
            self.activitiesManager.addActivity(Activity(
                name: self.activityName,
                type: self.activityManager.activity.type,
                sequence: self.activityManager.activity.sequence
            ))
        }
        
        // self.activityManager.resetSteps()
        self.dismiss()
    }
}

struct AddStepView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var activityManager: ActivityManager

    @State private var stepDescription = ""
    @State private var stepImage: Data?
    @State private var showCamera = false
    @State private var showImagePicker = false

    let stepIndex: Int? // Pass this if you're editing an existing step
    
    init(_ manager: Binding<ActivityManager>,stepIndex: Int? = nil) {
        self._activityManager = manager
        self.stepIndex = stepIndex
    }
    
    var body: some View {
        Form {
            Section(header: Text("Step Details")) {
                TextField("Enter Step Description", text: self.$stepDescription)
                
                Button("Take Photo...") {
                    self.showCamera = true
                }
                .sheet(isPresented: self.$showCamera) {
                    ImagePicker(self.$stepImage, .camera)
                        .onDisappear {
                            if let data = self.stepImage {
                                if let index = stepIndex {
                                    self.activityManager.setStepType(.image(data), at: index)
                                } else {
                                    self.addStep(data)
                                }
                            }
                        }
                }
                
                Button("Choose Step Image...") {
                    self.showImagePicker = true
                }
                .sheet(isPresented: self.$showImagePicker) {
                    ImagePicker(self.$stepImage)
                }
                
                if let data = self.stepImage, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                } else {
                    Text("Image not available")
                }
            }
            
            Section {
                Button(stepIndex == nil ? "Add Step" : "Update Step") {
                    self.saveStep(self.stepImage)
                    self.stepDescription = ""
                    self.stepImage = nil
                }
            }
        }
        .onAppear {
            if let index = stepIndex {
                if let step = self.activityManager.activity.sequence[safe: index] {
                    self.stepDescription = step.description
                    if case let .image(data) = step.type {
                        self.stepImage = data
                    }
                }
            }
        }
        .navigationBarTitle(stepIndex == nil ? "Add Step" : "Edit Step", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            self.saveStep(self.stepImage)
            self.dismiss()
        })
    }
    
    private func saveStep(_ data: Data?) {
        guard !self.stepDescription.isEmpty else { return }
        
        let type: ActivityType? = if let data { .image(data) } else { nil }
        let step = Step(type: type, description: self.stepDescription)
        
        if let index = self.stepIndex {
            // Update existing step
            self.activityManager.setStep(step, at: index)
        } else {
            // Add new step
            self.activityManager.addStep(step)
        }
    }
    
    private func addStep(_ data: Data) {
        guard !self.stepDescription.isEmpty else { return }
        
        let step = Step(type: .image(data), description: self.stepDescription)
        
        self.activityManager.addStep(step)
    }
}






