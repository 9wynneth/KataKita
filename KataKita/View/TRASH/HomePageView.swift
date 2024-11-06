import SwiftUI

struct HomePageView: View {
    @State private var selectedOption: String = "Jadwal"
    @State private var shouldNavigate: Bool = false
    @State private var showsettings = false
    
    var body: some View {
       
        NavigationStack {
            VStack {
                Spacer()
                
                TextHeadline(text: "Makkata", size: 60, color: "00000", transparency: 1.0, weight: "bold")
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: DailyActivityView()) {
                        
                        CustomButton(
                            icon: "calendar", text: "JADWAL", width: 280, height: 280,
                            font: 40, iconWidth: 60, iconHeight: 60, bgColor: "#ffffff",
                            bgTransparency: 1.0, fontColor: "#555555",
                            fontTransparency: 1.0, cornerRadius: 20,
                            action: {
                                selectedOption = "Jadwal"
                                shouldNavigate = true
                            }
                        )
                        .padding(.trailing, 30)
                    }
                    NavigationLink(destination: EmptyView()) {
                        
                        CustomButton(
                            icon: "keyboard", text: "AAC", width: 280, height: 280,
                            font: 40, iconWidth: 60, iconHeight: 60, bgColor: "#ffffff",
                            bgTransparency: 1.0, fontColor: "#555555",
                            fontTransparency: 1.0, cornerRadius: 20,
                            action: {
                                selectedOption = "AAC"
                                shouldNavigate = true
                            }
                        )
                        .padding(.leading, 30)
                    }
                }
                Spacer()
//                NavigationLink(destination: SettingsView(showsettings = $showsettings)) {
//                    CustomButton(
//                        icon: "settings", width: 100, height: 100, font: 50,
//                        iconWidth: 50, iconHeight: 50, bgColor: "#ffffff",
//                        bgTransparency: 1.0, fontColor: "#696767",
//                        fontTransparency: 1.0, cornerRadius: 20, isSystemImage: false,
//                        action: {
//                            selectedOption = "Setting"
//                            shouldNavigate = true
//                        }
//                    )
//                }
                Spacer()
            }
            .background(Image("homebackground"))
//            NavigationLink(
////                destination: {
////                    switch selectedOption {
////                    case "Setting":
////                        AnyView(SettingsView())
////                    case "Jadwal":
////                        AnyView(DailyActivityView())
////                    case "AAC":
////                        AnyView(AACView())
////                    default:
////                        AnyView(EmptyView())
////                    }
//                }(),
//                isActive: $shouldNavigate,
//                label: {
//                    EmptyView()
//                }
//            )
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    HomePageView()
}
