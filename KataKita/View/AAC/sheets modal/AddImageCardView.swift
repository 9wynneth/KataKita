import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct AddImageCardView: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager
    @State private var isLoading = false
    @State private var tempImageURL: URL?
    
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
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(imageURL: $tempImageURL)
                                    .onDisappear {
                                        if let selectedURL = tempImageURL {
                                            originalImageManager.imageFromLocal = selectedURL
                                            stickerManager.stickerImage = nil
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
                            .sheet(isPresented: $showCamera) {
                                ImagePicker(sourceType: .camera, imageURL: $tempImageURL)
                                    .onDisappear {
                                        if let selectedURL = tempImageURL {
                                            originalImageManager.imageFromLocal = selectedURL
                                            stickerManager.stickerImage = nil
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
                    
                    if isLoading {
                        ProgressView("Processing...")
                    } else if let stickerURL = stickerManager.stickerImage,
                              let stickerImage = UIImage(contentsOfFile: stickerURL.path) {
                        Image(uiImage: stickerImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } else if let imagePath = originalImageManager.imageFromLocal,
                              let uiImage = UIImage(contentsOfFile: imagePath.path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    CustomButton(text: "SELESAI", width: 350, height: 50, font: 16, bgColor: "#013C5A", bgTransparency: 1.0, fontColor: "#ffffff", fontTransparency: 1.0, cornerRadius: 30) {
                        if originalImageManager.imageFromLocal != nil {
                            dismiss()
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
                // Fix orientation if needed
                let fixedImage = fixOrientation(of: uiImage)

                // Save the fixed image to a temporary file and set the imageURL to the URL path
                if let data = fixedImage.pngData() {
                    let filename = UUID().uuidString + ".png"
                    let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    try? data.write(to: path)
                    parent.imageURL = path
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

        // Helper function to fix image orientation
        private func fixOrientation(of image: UIImage) -> UIImage {
            if image.imageOrientation == .up {
                return image // No need to fix
            }

            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return fixedImage ?? image // Fallback to the original image if something goes wrong
        }
    }
}
