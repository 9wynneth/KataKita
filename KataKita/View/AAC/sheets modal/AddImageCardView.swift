import SwiftUI
import PhotosUI
import Vision
import CoreImage.CIFilterBuiltins

struct AddImageCardView: View {
    @Environment(StickerImageManager.self) var stickerManager
    @Environment(OriginalImageManager.self) var originalImageManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedColumnIndexValue: Int
    @Binding var CardName: String
    
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showingSymbolsView = false
    @State private var showAACSettings = true
    @State private var navigateToAddButton = false
    @State private var isLoading = false
    @State private var gambar: String? = ""
    @State private var tempImage: Data?

    init(selectedColumnIndexValue: Binding<Int>, CardName: Binding<String>) {
        self._selectedColumnIndexValue = selectedColumnIndexValue
        self._CardName = CardName
    }

    private var processingQueue = DispatchQueue(label: "ProcessingQueue")

    var body: some View {
        NavigationStack {
            ZStack{
                Color(hex: "BDD4CE", transparency: 1) // Background color for the whole view
                    .ignoresSafeArea()
                
            VStack {
                VStack(spacing: 12) {
                        HStack {
                            Button(action: {
                                showImagePicker = true
                                self.stickerManager.stickerImage = nil
                                self.originalImageManager.imageFromLocal = nil
                            }) {
                                HStack {
                                    Text(LocalizedStringKey("Pilih Gambar"))
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "photo")
                                        .foregroundColor(.black)
                                }
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(self.$tempImage)
                                    .onDisappear {
                                        // Update the image URL after selection and clear the sticker image
                                        if let data = self.tempImage {
                                            self.originalImageManager.imageFromLocal = data
                                            self.stickerManager.stickerImage = nil // Reset the sticker when new image is chosen
                                        }
                                    }
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Button(action: {
                                showCamera = true
                                self.stickerManager.stickerImage = nil
                                self.originalImageManager.imageFromLocal = nil
                            }) {
                                HStack {
                                    Text(LocalizedStringKey("Ambil Foto"))
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Image(systemName: "camera")
                                        .foregroundColor(.black)
                                }
                            }
                            .sheet(isPresented: $showCamera) {
                                ImagePicker($tempImage, .camera)
                                    .onDisappear {
                                        // Update the image URL after capture and clear the sticker image
                                        if let data = self.tempImage {
                                            self.originalImageManager.imageFromLocal = data
                                            self.stickerManager.stickerImage = nil // Reset the sticker when new photo is taken
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
                    
                    if self.isLoading {
                        ProgressView(LocalizedStringKey("Processing..."))
                    } else if let data = self.stickerManager.stickerImage, let uIImage = UIImage(data: data) {
                        Image(uiImage: uIImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .onAppear{
                                self.gambar = "sticker"
                                self.stickerManager.stickerImage = data
                            }
                            .onChange(of: self.stickerManager.stickerImage) {
                                if self.stickerManager.stickerImage != nil {
                                    self.gambar = "sticker"
                                }
                            }
                    } else if let data = self.originalImageManager.imageFromLocal, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .onAppear {
                                // If it's a new image, create a sticker from it, otherwise do nothing
                                if self.stickerManager.stickerImage == nil, let data = self.originalImageManager.imageFromLocal, let uiImage = UIImage(data: data) {
                                    self.createSticker(from: uiImage)
                                    self.gambar = "original"
                                }
                            }
                        
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
        }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextContent(
                        text: "Tambah Gambar", size: 25, color: "FFFFFF", transparency: 1.0,
                        weight: "medium")
                }
            }
            .navigationBarBackButtonHidden(true) // Sembunyikan tombol "Back" bawaan
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack{
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white) // Atur warna putih
                                .font(.system(size: 20, weight: .medium))
                            
                            TextContent(
                                text: "Kembali", size: 20, color: "FFFFFF",
                                transparency: 1.0,
                                weight: "medium")
                        }
                    }
                }
            }
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
    private func saveImageToTemporaryFile(_ image: UIImage) -> Data? {
        guard let data = image.pngData() else {
            print("Failed to get image data")
            return nil
        }
        return data
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
    @Binding var imageData: Data?
    
    private let sourceType: UIImagePickerController.SourceType
    
    init( _ data: Binding<Data?>, _ source: UIImagePickerController.SourceType = .photoLibrary) {
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Fix orientation if needed
                let fixedImage = fixOrientation(of: uiImage)

                // Save the fixed image to a temporary file and set the imageURL to the URL path
                if let data = fixedImage.pngData() {
                    self.parent.imageData = data
                }
            }
            print("Dismiss on Get Image")
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Dismiss on Cancel")
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
