//
//  AddActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 10/11/24.
//
import SwiftUI

struct AddActivityView: View {
    @Environment(ActivityManager.self) private var activityManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(StateManager.self) private var stateManager // Inject StateManager

    @State private var showImagePicker = false
    @State private var tempImageURL: URL?
    @State private var activityName = ""
    @State private var navigateToAddStep = false
    
    //MARK: viewport size
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
                    
                    Button("Choose Activity Image...") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageURL: $tempImageURL)
                            .onDisappear {
                                if let selectedURL = tempImageURL {
                                    activityManager.setImage(image: selectedURL.path)  // Save path as string
                                }
                            }
                    }
                    
                    if let imageURL = tempImageURL, let uiImage = UIImage(contentsOfFile: imageURL.path) {
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
                    Button("Add Step") {
                        navigateToAddStep = true
                    }
                    .navigationDestination(isPresented: $navigateToAddStep) {
                        AddStepView()
                    }
                }

                Section(header: Text("Steps")) {
                    ForEach(Array(getSteps().enumerated()), id: \.offset) { i, step in
                        Text(step.description)
                        if let uiImage = UIImage(contentsOfFile: step.image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Text("Image not available")
                            }
                    }
                }
            }
            .navigationBarTitle("Add New Activity", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveActivity()
                dismiss()
            })
        }
        .onAppear {
            print("Steps count: \(getSteps().count)") // Debugging log to verify steps count
        }

    }

    private func getSteps() -> [Step] {
        return activityManager.activity.sequence
    }

    private func saveActivity() {
        let activity = Activity(
            id: UUID(),
            name: activityName,
            image: activityManager.activity.image,
            ruangan: Ruangan(id: UUID(), name: "Room 1"),
            sequence: activityManager.activity.sequence // Pass the current steps
        )
        activitiesManager.addActivity(activity)
        
        // After saving, reset steps in activityManager to avoid carryover
        activityManager.resetSteps()
    }
}

struct AddStepView: View {
    @Environment(ActivityManager.self) private var activityManager

    @State private var stepDescription = ""
    @State private var stepImageURL: URL?
    @State private var showImagePicker = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Step Details")) {
                TextField("Enter Step Description", text: $stepDescription)
                
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
                }
            }

            Section {
                Button("Add Another Step") {
                    addStep()
                }
            }
        }
        .navigationBarTitle("Add Step", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            addStep()
            dismiss()
        })
    }

    private func addStep() {
        guard !stepDescription.isEmpty else { return }

        let step = Step(image: stepImageURL?.path ?? "", description: stepDescription)

        activityManager.addStep(step)

        stepDescription = ""
        stepImageURL = nil
    }
}

