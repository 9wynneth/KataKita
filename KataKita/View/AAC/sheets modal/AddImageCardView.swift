import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct AddImageCardView: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showingSymbolsView = false
    @State private var showAACSettings = true
    @State private var navigateToAddButton = false
    @Environment(StickerImageManager.self) var stickerManager
    @State private var isLoading = false
    @State private var gambar: String? = ""

    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColumnIndexValue: Int
    @Binding var CardName: String
    @Environment(OriginalImageManager.self) var originalImageManager
    @State private var tempImageURL: URL?


    init(selectedColumnIndexValue: Binding<Int>, CardName: Binding<String>) {
        self._selectedColumnIndexValue = selectedColumnIndexValue
        self._CardName = CardName
    }

    private var processingQueue = DispatchQueue(label: "ProcessingQueue")

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Choose Image...") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageURL: $tempImageURL)
                            .onDisappear {
                                // Update the image URL after selection and clear the sticker image
                                if let selectedURL = tempImageURL {
                                    originalImageManager.imageFromLocal = selectedURL
                                    stickerManager.stickerImage = nil // Reset the sticker when new image is chosen
                                }
                            }
                    }

                    Button("Take Photo...") {
                        showCamera = true
                    }
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, imageURL: $tempImageURL)
                            .onDisappear {
                                // Update the image URL after capture and clear the sticker image
                                if let selectedURL = tempImageURL {
                                    originalImageManager.imageFromLocal = selectedURL
                                    stickerManager.stickerImage = nil // Reset the sticker when new photo is taken
                                }
                            }
                    }

                    if isLoading {
                        ProgressView("Processing...")
                    } else if let stickerURL = stickerManager.stickerImage,
                                let stickerImage = UIImage(contentsOfFile: stickerURL.path) {
                        Image(uiImage: stickerImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .onAppear{
                                gambar = "sticker"
                                print(gambar)
                            }
                            .onChange(of: stickerManager.stickerImage) { newSticker in
                                    // Trigger any logic when the sticker image is updated
                                    if newSticker != nil {
                                        gambar = "sticker"
                                        print("Sticker updated")
                                    }
                                }
                    } else if let imagePath = originalImageManager.imageFromLocal, let uiImage = UIImage(contentsOfFile: imagePath.path) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .onAppear {
                                // If it's a new image, create a sticker from it, otherwise do nothing
                                if stickerManager.stickerImage == nil, let imagePath = originalImageManager.imageFromLocal, let uiImage = UIImage(contentsOfFile: imagePath.path) {
                                    createSticker(from: uiImage)
                                    gambar = "original"
                                    print(gambar)
                                }
                            }

                    } else {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Add Image", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(LocalizedStringKey("Selesai")) {
                    if originalImageManager.imageFromLocal != nil {
                        dismiss()
                    }
                }
            )
          
        }
    }

    // MARK: - Sticker creation using Vision and Core Image
    private func createSticker(from image: UIImage) {
        guard let inputCIImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return
        }

        isLoading = true // Start loading

        processingQueue.async {
            guard let maskImage = self.subjectMaskImage(from: inputCIImage) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    // Fallback to original image: Save the image as a file and assign the URL to stickerManager
                    self.stickerManager.stickerImage = self.saveImageToTemporaryFile(image)
                    print("Failed to create mask image")
                }
                return
            }

            let outputImage = self.apply(mask: maskImage, to: inputCIImage)
            let finalImage = self.render(ciImage: outputImage)

            DispatchQueue.main.async {
                self.stickerManager.stickerImage = self.saveImageToTemporaryFile(finalImage)
                self.isLoading = false
            }
        }
    }

    // Helper function to save UIImage to a temporary file and return the URL
    private func saveImageToTemporaryFile(_ image: UIImage) -> URL? {
        guard let data = image.pngData() else {
            print("Failed to get image data")
            return nil
        }
        
        let filename = UUID().uuidString + ".png"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: path)
            return path // Return the URL of the saved file
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }


    private func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        let request = VNGenerateForegroundInstanceMaskRequest()
        do {
            try handler.perform([request])
            guard let result = request.results?.first else {
                print("No observations found")
                return nil
            }
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            print("Error generating mask: \(error)")
            return nil
        }
    }

    private func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }

    private func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
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
