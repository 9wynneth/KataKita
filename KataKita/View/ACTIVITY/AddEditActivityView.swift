//
//  AddEditActivityView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 18/11/24.
//

//
//  AddEditActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 15/11/24.
//

import SwiftUI


// Updated CardCreateView
struct AddEditActivityView: View {
    @State private var textToSpeak: String = ""
    @State private var selectedIcon: String = ""
    @State private var showingAddImageView = false
    @State private var navigatesFromImage = false
    @State private var navigateToCekVMView = false
    @State private var addingCard: Int? = nil
    @State private var isGender = false
    @Environment(OriginalImageManager.self) var originalImageManager
    @Environment(ActivitiesManager.self) var activitiesManager
    @State var isEditing: Bool = false
    
    @Binding var tempImage: Data?
    @State private var selectedStepIndex: Int?
    @State private var showStepImagePicker = false // Separate state for step image picker
    @State private var tempStepImage: Data? // Separate for step images
    
    @Binding var navigateFromImage: Bool
    @Binding var selectedColumnIndexValue: Int
    @Binding var showAACSettings: Bool
    @State private var navigateToAddStep = false
    
    @State private var name = ""
    @State private var type: CardType? = nil
    
    @State private var isImageType = false
    @State private var filteredAssets: [String] = []
    @Environment(ProfileViewModel.self) private var viewModel
    @State private var activityManager = ActivityManager()
    
    @Binding var activityToEdit: Activity?
    @Binding var editUlang: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Section {
                        VStack{
                            if !navigateFromImage {
                                VStack(alignment: .leading, spacing: 4) {
                                    TextContent(
                                        text: "AKTIVITAS DETIL", size: 15, color: "FFFFFF", transparency: 1.0,
                                        weight: "regular")
                                    VStack(alignment: .leading, spacing: 4) {
                                        TextField(LocalizedStringKey("Tambah Aktivitas Baru"), text: $textToSpeak)
                                            .onChange(of: textToSpeak) {
                                                textToSpeak = textToSpeak.lowercased()
                                                navigatesFromImage = false
                                                filteredAssets = filterAssets(by: textToSpeak, for: viewModel.userProfile.gender)
                                            }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .frame(height: 130)
                                
                                HStack {
                                    if let data = self.tempImage, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(20)
                                    } else {
                                        // Display icons if no image is selected
                                        if !filteredAssets.isEmpty {
                                            VStack(alignment: .leading) {
                                                HStack {
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
                                                                navigatesFromImage = true
                                                                textToSpeak = assetName
                                                                if textToSpeak.hasPrefix("GIRL_") {
                                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "GIRL_", with: "")
                                                                    isGender = true
                                                                } else if textToSpeak.hasPrefix("BOY_") {
                                                                    textToSpeak = textToSpeak.replacingOccurrences(of: "BOY_", with: "")
                                                                    isGender = true
                                                                }
                                                                else {
                                                                    isGender = false
                                                                }
                                                                filteredAssets = [assetName]
                                                                isImageType = false
                                                            }
                                                        )
                                                    }
                                                }
                                            }
                                        } else if !textToSpeak.isEmpty {
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
                                        }
                                    }
                                    
                                    CustomButton(
                                        icon: "plus",
                                        width: 100,
                                        height: 100,
                                        font: 40,
                                        iconWidth: 50,
                                        iconHeight: 50,
                                        bgColor: "#FFFFFF",
                                        bgTransparency: 1.0,
                                        fontColor: "#000000",
                                        fontTransparency: 1.0,
                                        cornerRadius: 20,
                                        isSystemImage: true,
                                        action: {
                                            showingAddImageView = true
                                            navigatesFromImage = false
                                        }
                                    )
                                    .opacity(navigatesFromImage ? 0 : 1)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        
                    }
                    // MARK: Sequence
                    
                    Button("Add Step") {
                        self.navigateToAddStep = true
                    }
                    VStack(alignment: .leading) {
                        ForEach(Array(self.getSteps().enumerated()), id: \.offset) { index, step in
                            VStack(alignment: .leading, spacing: 10) {
                                if self.activityToEdit != nil || self.editUlang || self.isEditing {
                                    TextField("Step Description", text: Binding(
                                        get: { step.description },
                                        set: { newDescription in
                                            self.activityManager.setStepDescription(description: newDescription, at: index)
                                        }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.bottom, 10)
                                    
                                    Button("Change Step Image") {
                                        self.selectedStepIndex = index
                                        self.showStepImagePicker = true
                                    }
                                    .padding(.bottom, 10)
                                    .foregroundColor(.blue)
                                    
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
                                    
                                    // Display the image if available
                                    if case let .image(data) = step.type {
                                        if let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                                .padding(.bottom, 10)
                                        }
                                    } else if case let .icon(icon) = step.type {
                                        Icon(icon, (100, 100))
                                            .padding(.bottom, 10)
                                    } else {
                                        Text("No image available")
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 10)
                                    }
                                } else {
                                    // Display step description and image/icon if not in editing mode
                                    Text(step.description)
                                        .font(.body)
                                        .padding(.bottom, 5)

                                    // Display the image if available
                                    if case let .image(data) = step.type {
                                        if let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                                .padding(.bottom, 5)
                                        }
                                    } else if case let .icon(icon) = step.type {
                                        Icon(icon, (100, 100))
                                            .padding(.bottom, 5)
                                    } else {
                                        Text("No image available")
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 5)
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal, 10)
                        }
                    }

                    
                    
                    Spacer()
                    
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                        if !textToSpeak.isEmpty {
                            handleDoneAction()
                            showAACSettings = false
                            self.saveOrUpdateActivity()
                            self.dismiss()
                        }
                    }
                    .padding(.bottom, 20)
                }
                
            }
            .navigationDestination(isPresented: self.$navigateToAddStep) {
                AddStepView2(self.$activityManager)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextContent(
                        text: "Tambah Aktivitas Baru", size: 25, color: "FFFFFF", transparency: 1.0,
                        weight: "medium")
                }
            }
            .navigationDestination(isPresented: $showingAddImageView) {
                AddImageCardView2(
                    selectedColumnIndexValue: $selectedColumnIndexValue,
                    CardName: $textToSpeak
                )
            }
            .toolbar {
                if !getSteps().isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(self.isEditing ? "Cancel" : "Edit") {
                            self.isEditing.toggle()
                        }
                    }
                }
            }
            
            
        }
        
        .onChange(of: self.textToSpeak) {
            self.activityManager.setName(self.textToSpeak)
        }
        .onAppear {
            if let activity = self.activityToEdit {
                self.activityManager.activity = activity
                self.textToSpeak = activity.name
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
        guard !textToSpeak.isEmpty else { return }
        
        if let activityToEdit = self.activityToEdit {
            activityToEdit.name = self.textToSpeak
            activityToEdit.type = self.activityManager.activity.type
            activityToEdit.sequence = self.activityManager.activity.sequence
            self.activitiesManager.updateActivity(activityToEdit)
        } else {
            self.activitiesManager.addActivity(Activity(
                name: self.textToSpeak,
                type: self.activityManager.activity.type,
                sequence: self.activityManager.activity.sequence
            ))
        }
        
        // self.activityManager.resetSteps()
        self.dismiss()
    }
    private func handleDoneAction() {
        // Check if it's a sticker
        
        
        // Handle the card creation
        
        if Locale.current.language.languageCode?.identifier == "en" {
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(selectedIcon.lowercased()) {
                    selectedIcon = "GIRL_" + selectedIcon.uppercased()
                } else {
                    selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(selectedIcon.lowercased()) {
                    selectedIcon = "BOY_" + selectedIcon.uppercased()
                } else {
                    selectedIcon = NSLocalizedString(selectedIcon, comment: "")
                }
            }
        }
        else {
            selectedIcon = NSLocalizedString(selectedIcon, comment: "")
        }
        
        // Localize only when displaying in SwiftUI
        if Locale.current.language.languageCode?.identifier == "en" {
            let localizedIcon = NSLocalizedString(textToSpeak.uppercased(), comment: "")
            if viewModel.userProfile.gender == true {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "GIRL_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
            else {
                if AllAssets.shared.genderAssets.contains(textToSpeak.lowercased()) {
                    textToSpeak = "BOY_" + localizedIcon.uppercased()
                } else {
                    textToSpeak = NSLocalizedString(textToSpeak, comment: "")
                }
            }
        }
        else {
            textToSpeak = NSLocalizedString(textToSpeak, comment: "")
        }
        if !isImageType {
            selectedIcon = textToSpeak.lowercased()
            self.type = .icon(selectedIcon)
        }
        print("icon " + textToSpeak)
        
        self.activityManager.setName(self.textToSpeak)
        //        boardManager.addCard(Card(name: textToSpeak, category: selectedCategory, type: self.type), column: selectedColumnIndexValue)
        
        // Reset the image state after the card has been added
        originalImageManager.imageFromLocal = nil
        
        // Dismiss the view
        self.addingCard = nil
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
        }
        else {
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
}


struct AddStepView2: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activityManager: ActivityManager
    
    @State private var stepDescription = ""
    @State private var stepImage: Data?
    @State private var showCamera = false
    @State private var showImagePicker = false
    
    let stepIndex: Int? // Pass this if you're editing an existing step
    
    init(_ manager: Binding<ActivityManager>, stepIndex: Int? = nil) {
        self._activityManager = manager
        self.stepIndex = stepIndex
    }
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "BDD4CE", transparency: 1.0)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Input Section
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Enter Step Description", text: $stepDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Buttons for Image Picker and Camera
                    HStack {
                        Button(action: { showCamera = true }) {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(.blue)
                                Text("Take Photo")
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker($stepImage, .camera)
                                .onDisappear(perform: handleImageSelection)
                        }
                        
                        Spacer()
                        
                        Button(action: { showImagePicker = true }) {
                            HStack {
                                Image(systemName: "photo")
                                    .foregroundColor(.blue)
                                Text("Choose Image")
                                    .foregroundColor(.blue)
                            }
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker($stepImage)
                                .onDisappear(perform: handleImageSelection)
                        }
                    }
                    
                    // Image Preview
                    if let data = stepImage, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: saveStep) {
                        Text(stepIndex == nil ? "Add Step" : "Update Step")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    
                   
                }
                .padding(.horizontal)
                Spacer()
                CustomButton(
                    text: "SELESAI",
                    width: 350,
                    height: 50,
                    font: 16,
                    bgColor: "#013C5A",
                    bgTransparency: 1.0,
                    fontColor: "#FFFFFF",
                    fontTransparency: 1.0,
                    cornerRadius: 30
                ) {
                    saveStep()
                    dismiss()
                }
            }
            .padding()
        }
        .onAppear(perform: loadStep)
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextContent(
                    text: "Tambah Langkah Baru",
                    size: 25,
                    color: "FFFFFF",
                    transparency: 1.0,
                    weight: "medium"
                )
            }
        }
    }
    
    private func loadStep() {
        if let index = stepIndex, let step = activityManager.activity.sequence[safe: index] {
            stepDescription = step.description
            if case let .image(data) = step.type {
                stepImage = data
            }
        }
    }
    
    private func saveStep() {
        guard !stepDescription.isEmpty else { return }
        
        let type: ActivityType? = stepImage.flatMap { .image($0) }
        let step = Step(type: type, description: stepDescription)
        
        if let index = stepIndex {
            activityManager.setStep(step, at: index)
        } else {
            activityManager.addStep(step)
        }
        
        stepDescription = ""
        stepImage = nil
    }
    
    private func handleImageSelection() {
        if let data = stepImage {
            if let index = stepIndex {
                activityManager.setStepType(.image(data), at: index)
            } else {
                addStep(data)
            }
        }
    }
    
    private func addStep(_ data: Data) {
        guard !stepDescription.isEmpty else { return }
        let step = Step(type: .image(data), description: stepDescription)
        activityManager.addStep(step)
    }
}


import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct AddImageCardView2: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager
    @Environment(ActivityManager.self) var activityManager
    
    @State private var isLoading = false
    @State private var tempImageURL: URL?
    @State private var activityName = ""
    @State private var tempImage: Data? // Used only for activity image
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColumnIndexValue: Int
    @Binding var CardName: String
    
    init(selectedColumnIndexValue: Binding<Int>, CardName: Binding<String>) {
        self._selectedColumnIndexValue = selectedColumnIndexValue
        self._CardName = CardName
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 12) {
                        //                        TextField("Enter Activity Name", text: self.$activityName)
                        HStack {
                            Button(action: { showImagePicker = true }) {
                                HStack {
                                    Text("Pilih Gambar")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "photo")
                                        .foregroundColor(.black)
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
                        }
                        
                        Divider()
                        
                        HStack {
                            Button(action: { showCamera = true }) {
                                HStack {
                                    Text("Ambil Foto")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "camera")
                                        .foregroundColor(.black)
                                }
                            }
                            .sheet(isPresented: self.$showCamera) {
                                ImagePicker(self.$tempImage, .camera)
                                    .onDisappear {
                                        if let data = self.tempImage {
                                            self.activityManager.setType(.image(data))
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    HStack {
                        if let data = self.tempImage, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                        } else {
                            Text("No image selected")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                        switch activityManager.activity.type {
                        case .image(let data):
                            if data != nil {
                                dismiss()
                            }
                        case .icon:
                            print("Activity is an icon")
                        case nil:
                            print("Activity type is nil")
                        }
                        
                    }
                    .padding(.bottom, 20)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextContent(
                            text: "Tambah Gambar", size: 25, color: "FFFFFF", transparency: 1.0,
                            weight: "medium")
                    }
                }        }
        }
    }
}
