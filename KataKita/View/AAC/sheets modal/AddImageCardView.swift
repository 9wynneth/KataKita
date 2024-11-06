import SwiftUI
import PhotosUI

struct AddImageCardView: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showingSymbolsView = false
    @State private var showAACSettings = true
    @State private var navigateToAddButton = false
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColumnIndexValue: Int
    @Binding var CardName: String
    @Binding var imageFromLocal: URL?  
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Choose Image...") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageURL: $imageFromLocal)
                    }

                    Button("Take Photo...") {
                        showCamera = true
                    }
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, imageURL: $imageFromLocal)
                    }

                    if let imagePath = imageFromLocal, let uiImage = UIImage(contentsOfFile: imagePath.path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(20)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Add Image", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    if imageFromLocal != nil {
                        dismiss()
                    }
                }
            )
        }
    }
}


// MARK: - ImagePicker Helper (Modified to Save Path as URL)
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var imageURL: URL?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Save the image to a file and set the imageURL to the URL path
                if let data = uiImage.pngData() {
                    let filename = UUID().uuidString + ".png"
                    let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    try? data.write(to: path)
                    parent.imageURL = path  // Set the URL directly
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
