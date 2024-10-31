import SwiftUI
import PhotosUI

struct AddImageAACTemplateView: View {
    @ObservedObject var viewModel: AACTemplateViewModel
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showingSymbolsView = false
    @State private var navigateToAddButton = false
    @State private var selectedSymbol = UIImage()
    @State var imageFromLocal: String = ""
    
    @Binding var categoryColor: String
    @Binding var selectedColumnIndex: [Card]
    
    @Binding var selectedColumnIndexValue: Int
    @Binding var selectedRowIndexValue: Int
    
    @Binding var CardName: String
    @State private var isEditingCard = true
    @State private var navigateFromFile = true
    

    var body: some View {
        NavigationStack {
            Form {
                Section {

                    Button("Choose Image...") {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(imageString: $imageFromLocal)
                    }

                    Button("Take Photo...") {
                        showCamera = true
                    }
                    .sheet(isPresented: $showCamera) {
                        ImagePicker(sourceType: .camera, imageString: $imageFromLocal)
                    }

                    if UIImage(named: imageFromLocal) != nil {
                        Image(uiImage: UIImage(named: imageFromLocal)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToAddButton) {
                EditCardView(
                    viewModel: viewModel,
                    CardName: $CardName,
                    CardPicture: $imageFromLocal,
                    categoryColor: $categoryColor,
                    selectedColumnIndex: $selectedColumnIndex,
                    selectedColumnIndexValue: $selectedColumnIndexValue, // Pass column index
                    selectedRowIndexValue: $selectedRowIndexValue,
                    isEditingCard: $isEditingCard, navigateFromFile: $navigateFromFile
                )
            }
        }
        .navigationBarTitle("Add Image", displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Done") {
                if !imageFromLocal.isEmpty {
                    navigateToAddButton = true  // Trigger navigation
                    
                }
            }
        )
    }
}
