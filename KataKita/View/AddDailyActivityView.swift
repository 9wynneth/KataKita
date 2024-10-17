//
//  AddDailyActivityView.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 10/10/24.
//

import SwiftUI

struct AddDailyActivityView: View {
    @Environment(ScheduleManager.self) private var scheduleManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""
    @State private var selectedDayString: Int = 0
    // Viewport size
    private let viewPortWidth: CGFloat = UIScreen.main.bounds.width - 100
    private let viewPortHeight: CGFloat = UIScreen.main.bounds.height - 100

    /// Computed Property
    var selectedDay: Day {
        switch selectedDayString {
            case 0:
                return .SUNDAY([])
            case 1:
                return .MONDAY([])
            case 2:
                return .TUESDAY([])
            case 3:
                return .WEDNESDAY([])
            case 4:
                return .THURSDAY([])
            case 5:
                return .FRIDAY([])
            default:
                return .SATURDAY([])
        }
    }
    var day: Day {
        return self.scheduleManager.schedules.first(where: {
            $0.day == selectedDay
        })?.day ?? selectedDay
    }
    var extractActivity: [Activity] {
        return self.day.extractActivities()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 30) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .frame(width: 15, height: 15)
                    TextHeadline(
                        text: "Pengaturan",
                        size: 20,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                    )
                }
                TextHeadline(
                    text: "Jadwal",
                    size: 36,
                    color: "Black",
                    transparency: 1.0,
                    weight: "Light"
                )
            }
            .padding(EdgeInsets(top: 50, leading: 50, bottom: 0, trailing: 50))
            .frame(height: 150, alignment: .topLeading)
            HStack {
                VStack(alignment: .leading) {
                    TextHeadline(
                        text: "Aktivitas yang dipilih",
                        size: 24,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                    )
                    HStack(spacing: 20) {
                        TextHeadline (
                            text: "Hari",
                            size: 20,
                            color: "Black",
                            transparency: 1.0,
                            weight: "Light"
                        )
                        Spacer()
                        Picker("Hari", selection: $selectedDayString) {
                            Text("Minggu").tag(0)
                            Text("Senin").tag(1)
                            Text("Selasa").tag(2)
                            Text("Rabu").tag(3)
                            Text("Kamis").tag(4)
                            Text("Jumat").tag(5)
                            Text("Sabtu").tag(6)
                        }
                        .accentColor(Color(hex: "B4B4B5"))
                    }
                    .padding(15)
                    .background (
                        RoundedRectangle(cornerRadius: 10)
                            
                            .fill(Color(hex: "F7F5F0", transparency: 1.0))
                    )
                    ZStack {
                        if extractActivity.isEmpty {
                            TextContent(
                                text: "Jadwal kosong",
                                size: 20,
                                color: "616161",
                                weight: "Light")
                        }
                        else {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(
                                        Array(extractActivity.enumerated()),
                                        id: \.offset
                                    ) { index, activity in
                                        SettingActivityCard(
                                            activity,
                                            number: index + 1,
                                            delete: {
                                                self.scheduleManager.removeActivity(
                                                    index: index, day: self.day)
                                            }
                                        )
                                    }
                                }.padding(.bottom, 140)
                            }
                        }
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "BDD4CE", transparency: 0), Color(hex: "BDD4CE", transparency: 1.0)],
                                        startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: 70)
                            Rectangle()
                                .fill(Color(hex: "BDD4CE", transparency: 1.0))
                                .frame(height: 100)
                        }
                        VStack {
                            Spacer()
                            Button {
                                self.scheduleManager.removeAll(self.day)
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        Color(hex: "EB7D7B")
                                    )
                                    .frame(width: 150, height: 40)
                                    .overlay(
                                        TextContent(
                                            text: "Hapus Semua",
                                            size: 15,
                                            color: "FBFBFB",
                                            weight: "semibold"
                                        )
                                    )
                            }
                        }
                    }
                }
                .padding(30)
                .frame(
                    width: viewPortWidth * 0.5,
                    alignment: .topLeading
                )
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "BDD4CE", transparency: 1.0)))

                // View Kanan (Daftar aktivitas)
                VStack(alignment: .leading) {
                    TextHeadline (
                        text: "Daftar Aktivitas",
                        size: 24,
                        color: "Black",
                        transparency: 1.0,
                        weight: "Light"
                )
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "E0E0E1", transparency: 1.0))
                    )

                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(activitiesManager.activities) { activity in
                                SettingActivityCard(activity)
                                    .onTapGesture {
                                        /// Click handler
                                        self.scheduleManager.addActivity(
                                            activity, day: self.day)
                                    }
                            }
                        }
                    }
                }
                .padding(.leading, 30)
                .frame(
                    width: viewPortWidth * 0.5,
                    alignment: .topLeading
                )
            }
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 50, trailing: 50))
            .frame(height: viewPortHeight - 50)
        }
        .background(
            Rectangle()
                .fill(Color(hex: "FBFBFB", transparency: 1.0))
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
    }
}
