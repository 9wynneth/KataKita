// sheet
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
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var activityManager = ActivityManager()
    @State private var textToSpeak: String = ""
    @State private var isGender = false
    @State private var navigatesFromImage = false
    
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
    @State private var filteredAssets: [String] = []
    
    let viewPortWidth = UIScreen.main.bounds.width
    let viewPortHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "BDD4CE", transparency: 1)
                    .ignoresSafeArea()
                VStack {
                    // MARK: ActivityType.image Picker
                    //                Section(header: Text("Activity Details"))
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextContent(
                                text: "ACTIVITY DETAILS",
                                size: 15,
                                color: "FFFFFF",
                                transparency: 1.0,
                                weight: "regular"
                            )
                            .padding(.horizontal)
                            VStack(alignment: .leading, spacing: 4) {
                                TextField(LocalizedStringKey("Tambah Kata Baru"), text: $activityName)
                                    .onChange(of: activityName) {
                                        activityName = activityName.lowercased()
                                        navigatesFromImage = false
                                        filteredAssets = filterAssets(by: activityName, for: viewModel.userProfile.gender)
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                            
                            
                            if !filteredAssets.isEmpty {
                                VStack(alignment: .center) {
                                    HStack {
                                        Spacer()
                                        ForEach(filteredAssets.prefix(3), id: \.self) { assetName in
                                            CustomButtonSearch(
                                                icon: getDisplayIcon(for: assetName),
                                                text: getDisplayText(for: assetName),
                                                width: 100,
                                                height: 100,
                                                font: 20,
                                                iconWidth: 50,
                                                iconHeight: 50,
                                                bgColor: "#FFFFFF",
                                                bgTransparency: 1.0,
                                                fontColor: "#000000",
                                                fontTransparency: 1.0,
                                                cornerRadius: 20,
                                                isSystemImage: assetName.contains("person.fill"),
                                                action: {
                                                    self.activityManager.setType(.icon(getDisplayIcon(for: assetName)))
                                                    self.activityName = assetName
                                                    if self.activityName.hasPrefix("GIRL_") {
                                                        self.activityName = self.activityName.replacingOccurrences(of: "GIRL_", with: "")
                                                        self.isGender = true
                                                    } else if textToSpeak.hasPrefix("BOY_") {
                                                        self.activityName = self.activityName.replacingOccurrences(of: "BOY_", with: "")
                                                        self.isGender = true
                                                    }
                                                    else {
                                                        self.isGender = false
                                                    }
                                                    self.filteredAssets = [assetName]
                                                }
                                            )
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.horizontal)

                                
                            } else if !textToSpeak.isEmpty {
                                VStack {
                                    HStack {
                                        Spacer()
                                        CustomButtonSearch(
                                            text: textToSpeak,
                                            width: 100,
                                            height: 100,
                                            font: 20,
                                            bgColor: "#FFFFFF",
                                            bgTransparency: 1.0,
                                            fontColor: "#000000",
                                            fontTransparency: 1.0,
                                            cornerRadius: 20,
                                            action: {
                                                navigatesFromImage = true
                                            }
                                        )
                                        Spacer()
                                    }
                                    .padding(.horizontal)

                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.horizontal)

                            }
                            
                            VStack(spacing: 12) {
                                //                            Button("Take Photo...") {
                                //                                self.showCamera = true
                                //                            }
                                HStack {
                                    Button(action: { self.showCamera = true }) {
                                        HStack {
                                            Text("Take Photo")
                                                .foregroundColor(.blue)
                                            Spacer()
                                            Image(systemName: "camera")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                //                            Button("Choose Activity Image...") {
                                //                                self.showImagePicker = true
                                //                            }
                                HStack {
                                    Button(action: { self.showImagePicker = true }) {
                                        HStack {
                                            Text("Choose Activity Image")
                                                .foregroundColor(.blue)
                                            Spacer()
                                            Image(systemName: "photo")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                if let data = self.tempImage, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                }
                                Spacer()
                            }
                        }
                        
                        // MARK: Sequence
//                        Section(header: Text("Steps")) {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            TextContent(
                                text: "STEP DETAILS",
                                size: 15,
                                color: "FFFFFF",
                                transparency: 1.0,
                                weight: "regular"
                            )
                            .padding(.horizontal)
                            VStack(alignment: .leading, spacing: 4) {
                                
                            HStack {
                                Button(action: { self.navigateToAddStep = true }) {
                                    HStack {
                                        Text("Add step")
                                            .foregroundColor(.blue)
                                        Spacer()
                                        Image(systemName: "plus.app")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            //                            Button("Add Step") {
                            //                                self.navigateToAddStep = true
                            //                            }
                            Divider()
                            ForEach(Array(self.getSteps().enumerated()), id: \.offset) { index, step in
                                VStack(alignment: .leading) {
                                    if self.activityToEdit != nil || self.editUlang || self.isEditing {
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
                                    Divider()
                                }
                                .padding(.vertical, 5)
                            }
                        }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                            
                        }
                       
                        Spacer()
                    }
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30){
                        self.isEditing = false
                        self.saveOrUpdateActivity()
                        self.dismiss()
                    }
                        .padding(.bottom)
                }
                .padding(10)
                .onAppear {
                    print("Filtered Assets: \(filteredAssets)")
                }
                
                .sheet(isPresented: self.$showCamera) {
                    ImagePicker(self.$tempImage, .camera)
                        .onDisappear {
                            if let data = self.tempImage {
                                self.activityManager.setType(.image(data))
                            }
                        }
                    
                }
                .sheet(isPresented: self.$showImagePicker) {
                    ImagePicker(self.$tempImage)
                        .onDisappear {
                            if let data = self.tempImage {
                                self.activityManager.setType(.image(data))
                            }
                        }
                }
                .sheet(isPresented: self.$showStepImagePicker) {
                    ImagePicker(self.$tempStepImage) // Use tempStepImageURL here
                        .onChange(of: self.tempStepImage) {
                            if let data = self.tempStepImage {
                                self.activityManager.setStepType(.image(data), at: self.selectedStepIndex!)
                            }
                        }
                        .onDisappear {
                            if let data = self.tempStepImage, let index = self.selectedStepIndex {
                                self.activityManager.setStepType(.image(data), at: index)
                                self.tempStepImage = nil // Clear after use
                                self.selectedStepIndex = nil
                            }
                        }
                }
                .navigationDestination(isPresented: self.$navigateToAddStep) {
                    AddStepView(self.$activityManager)
                }
//                .navigationBarTitle(self.activityToEdit != nil ? "Edit Activity" : "Add New Activity", displayMode: .inline)
                .navigationBarItems(
                    leading: self.activityToEdit == nil ? Button(self.isEditing ? "Cancel" : "Edit") {
                        self.isEditing.toggle()
                    } : nil
//                    ,
//                    trailing: Button(self.isEditing ? "Save" : "Done") {
//                        self.isEditing = false
//                        self.saveOrUpdateActivity()
//                        self.dismiss()
//                    }
                )
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        
                        TextContent(
                            text: self.activityToEdit != nil ? "Edit Activity" : "Add New Activity", size: 25, color: "FFFFFF",
                            transparency: 1.0,
                            weight: "medium")
                    }
                }
            }
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
    private func getDisplayIcon(for icon: String) -> String {
        let lang = Locale.current.language.languageCode?.identifier ?? "id"
        if lang == "en" {
            let localizedIcon = NSLocalizedString(icon.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "GIRL_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "BOY_" + localizedIcon
                } else {
                    return icon
                    
                }
            }
        } else {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "GIRL_" + icon
                } else {
                    return icon
                    
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(icon) {
                    return "BOY_" + icon
                } else {
                    return icon
                    
                }
            }
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
    
    private func getDisplayText(for icon: String) -> String {
        if Locale.current.language.languageCode?.identifier == "en" {
            let localizedIcon = NSLocalizedString(icon, comment: "")
            let localizedIcon2 = NSLocalizedString(localizedIcon, comment: "")
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return localizedIcon2
                } else {
                    return icon
                    
                }
            }
        }
        else {
            if viewModel.userProfile.gender == true {
                if icon.hasPrefix("GIRL_") {
                    return icon.replacingOccurrences(of: "GIRL_", with: "")
                } else {
                    return icon
                    
                }
            }
            else {
                if icon.hasPrefix("BOY_") {
                    return icon.replacingOccurrences(of: "BOY_", with: "")
                } else {
                    return icon
                    
                }
            }
        }
        
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
        ZStack {
            Color(hex: "BDD4CE", transparency: 1)
                .ignoresSafeArea()
            
            VStack (alignment: .leading) {
                //            Section(header: Text("Step Details")) {
                VStack(alignment: .leading, spacing: 4) {
                    TextContent(
                        text: "STEPS",
                        size: 15,
                        color: "FFFFFF",
                        transparency: 1.0,
                        weight: "regular"
                    )
                    .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 10) {
                    TextField("Enter Step Description", text: self.$stepDescription)
                            .padding(.bottom, 5)
                    
//                    Button("Take Photo...") {
//                        self.showCamera = true
//                    }
                        HStack {
                            Button(action: { self.showCamera = true }) {
                                HStack {
                                    Text("Take Photo")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "camera")
                                        .foregroundColor(.black)
                                }
                            }
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
                    
                        Divider()
                        
//                    Button("Choose Step Image...") {
//                        self.showImagePicker = true
//                    }
                        HStack {
                            Button(action: { self.showImagePicker = true }) {
                                HStack {
                                    Text("Choose Step Image")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "photo")
                                        .foregroundColor(.black)
                                }
                            }
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
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal)
                
                VStack {
//                    Button(stepIndex == nil ? "Add Step" : "Update Step") {
//                        self.saveStep(self.stepImage)
//                        self.stepDescription = ""
//                        self.stepImage = nil
//                    }
                    
                    Button(action: { self.saveStep(self.stepImage)
                        self.stepDescription = ""
                        self.stepImage = nil }) {
                        HStack {
                            Text(stepIndex == nil ? "Add Step" : "Update Step")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "plus.app")
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal)
                    Spacer()
            }
                Spacer()
                HStack {
                    Spacer()
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30)
                    {
                        self.saveStep(self.stepImage)
                        self.dismiss()
                    }
                    Spacer()
                }
                .padding(.bottom)

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
//        .navigationBarTitle(stepIndex == nil ? "Add Step" : "Edit Step", displayMode: .inline)
//        .navigationBarItems(trailing: Button("Save") {
//            self.saveStep(self.stepImage)
//            self.dismiss()
//        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                
                TextContent(
                    text: stepIndex == nil ? "Add Step" : "Edit Step", size: 25, color: "FFFFFF",
                    transparency: 1.0,
                    weight: "medium")
            }
        }
    }
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






