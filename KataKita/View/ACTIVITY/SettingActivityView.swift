//
//  SettingActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/11/24.
//

import SwiftUI

struct SettingActivityView: View {
    
    var body: some View {
        NavigationStack {
            Form {
                // Profil Pengguna Section
                Section(header: Text("PROFIL PENGGUNA")) {
                    HStack {
                        Text("testsubject@icloud.com")
                        Spacer()
                        
                        HStack
                        {
                            Text("Detail")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Text("Warna Kulit")
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
//                        NavigationLink(destination: DetailView()) {
//
//                        }
                    }
                    HStack {
                        Text("Bahasa")
                        Spacer()
//                        NavigationLink(destination: DetailView()) {
//                            Text("Detail")
//                                .foregroundColor(.gray)
//                        }
                        HStack
                        {
                            Text("Detail")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                        }
                    }
                }
                
                // Pengaturan Kataloka Section
//                Section(header: Text("PENGATURAN KATALOKA")) {
//                    HStack {
//                        Text("Pengaturan Aktivitas Harian")
//                        Spacer()
//                        NavigationLink(destination: AddDailyActivityView()) {
//                            HStack{
//                                Spacer()
//                                
//                                Text("Detail")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        
//                    }
//                    
//                    HStack {
//                        Text("Pengaturan Urutan Aktifitas")
//                        Spacer()
////                        NavigationLink(destination: DetailView()) {
////                            Text("Detail")
////                                .foregroundColor(.gray)
////                        }
//                        HStack
//                        {
//                            Text("Detail")
//                                .foregroundColor(.gray)
//                            Image(systemName: "chevron.right")
//                                       .foregroundColor(.gray)
//                        }
//                    }
//                }
            }
            .navigationTitle("Pengaturan")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail Page")
    }
}

#Preview {
    SettingActivityView()
}
