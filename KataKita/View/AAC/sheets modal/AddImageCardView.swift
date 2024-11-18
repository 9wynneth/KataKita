import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct AddImageCardView: View {
    @State private var showImagePicker = false
    @State private var showCamera = false
    @Environment(StickerImageManager.self) var stickerManager
    @State private var isLoading = false
    @State private var tempImageURL: URL?
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColumnIndexValue: Int
    @Binding var CardName: String
    @Environment(OriginalImageManager.self) var originalImageManager
    @State private var tempImage: Data?
  
    init(selectedColumnIndexValue: Binding<Int>, CardName: Binding<String>) {
        self._selectedColumnIndexValue = selectedColumnIndexValue
        self._CardName = CardName
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button(LocalizedStringKey("Choose Image...")) {
                        self.showImagePicker = true
                    }
                    .sheet(isPresented: self.$showImagePicker) {
                        ImagePicker(self.$tempImage)
                            .onDisappear {
                                if let data = self.tempImage {
                                    self.originalImageManager.imageFromLocal = data
                                    self.stickerManager.stickerImage = nil // Reset the sticker when new image is chosen
                                }
                            }
                    }

                    Button(LocalizedStringKey("Take Photo...")) {
                        self.showCamera = true
                    }
                    .sheet(isPresented: self.$showCamera) {
                        ImagePicker($tempImage, .camera)
                            .onDisappear {
                                if let data = self.tempImage {
                                    self.originalImageManager.imageFromLocal = data
                                    self.stickerManager.stickerImage = nil // Reset the sticker when new photo is taken
                                }
                            }
                    }

                    if self.isLoading {
                        ProgressView(LocalizedStringKey("Processing..."))
                    } else if let data = self.stickerManager.stickerImage, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } else if let data = self.originalImageManager.imageFromLocal, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                            .onAppear {
                                if self.stickerManager.stickerImage == nil {
                                    self.createSticker(from: uiImage)
                                }
                            }
                    } else {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle(LocalizedStringKey("Add Image"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(LocalizedStringKey("Selesai")) {
                    if self.originalImageManager.imageFromLocal != nil {
                        self.dismiss()
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

        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async {
            guard let maskImage = self.subjectMaskImage(from: inputCIImage) else {
                DispatchQueue.main.async {
                    self.isLoading = false
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

    private func saveImageToTemporaryFile(_ image: UIImage) -> Data? {
        return image.pngData()
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
        return filter.outputImage ?? image
    }

    private func render(ciImage: CIImage) -> UIImage {
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    private let sourceType: UIImagePickerController.SourceType
    
    init(_ data: Binding<Data?>, _ source: UIImagePickerController.SourceType = .photoLibrary) {
        self._imageData = data
        self.sourceType = source
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = self.sourceType
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage, let data = uiImage.pngData() {
                parent.imageData = data
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
