import SwiftUI
import PhotosUI

struct AddImageAACView: View {
    @ObservedObject var viewModel: AACRuangMakanViewModel
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State var cobaimage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Display the image from a URL or show placeholder text if no image is selected
                if let url = URL(string: cobaimage) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } placeholder: {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                } else {
                    Text("Invalid image URL")
                        .foregroundColor(.red)
                }
                
                // Buttons to select or capture an image
                HStack {
                    Button("Choose Image...") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageString: $cobaimage)
                    }

                    Button("Take Photo...") {
                        showCamera = true
                    }
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, imageString: $cobaimage)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Add Image", displayMode: .inline)
        }
    }
}

// MARK: - ImagePicker Helper (Modified to Save Path as String URL)
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var imageString: String

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
                // Save the image to a file and set the imageString to the URL path
                if let data = uiImage.pngData() {
                    let filename = UUID().uuidString + ".png"
                    let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    try? data.write(to: path)
                    parent.imageString = path.absoluteString  // Set the URL as the string
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
