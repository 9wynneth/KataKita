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
    @State private var showEditActivityView = false
      @State private var selectedActivity: Activity?
    @State private var isAdd = false
    @State private var searchText: String = ""
    @State private var selectedDayString: Int = 0
    @Binding var toggleOn: Bool
    @State private var activityToEdit: Activity?
    
    // Viewport size
    private let viewPortWidth: CGFloat = UIScreen.main.bounds.width - 100
    private let viewPortHeight: CGFloat = UIScreen.main.bounds.height - 100
    
    init(toggleOn: Binding<Bool>) {
        _toggleOn = toggleOn
        _selectedDayString = State(initialValue: Calendar.current.component(.weekday, from: Date()) - 1)
    }
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
    var filteredActivities: [Activity] {
        if searchText.isEmpty {
            return activitiesManager.activities
        } else {
            return activitiesManager.activities.filter { activity in
                activity.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 30) {
                //                Button {
                //                    dismiss()
                //                } label: {
                //                    Image(systemName: "chevron.left")
                //                        .resizable()
                //                        .fontWeight(.medium)
                //                        .foregroundStyle(Color.black)
                //                        .frame(width: 15, height: 15)
                //                    TextHeadline(
                //                        text: "Pengaturan",
                //                        size: 20,
                //                        color: "Black",
                //                        transparency: 1.0,
                //                        weight: "Light"
                //                    )
                //                }
                HStack {
                    //                    TextHeadline(
                    //                        text: "Jadwal",
                    //                        size: 36,
                    //                        color: "Black",
                    //                        transparency: 1.0,
                    //                        weight: "Light"
                    //                    )
                    Spacer()
                    ZStack {
                        Capsule()
                            .frame(width: 80, height: 44)
                            .foregroundColor(Color.gray)
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Image(
                                systemName: toggleOn
                                ? "figure.and.child.holdinghands"
                                : "figure.child.and.lock.open")
                        }
                        .shadow(
                            color: .black.opacity(0.14), radius: 4,
                            x: 0, y: 2
                        )
                        .offset(x: toggleOn ? 18 : -18)
                        .padding(24)
                        .animation(.spring(duration: 0.25), value: toggleOn)
                    }
                    .onTapGesture {
                        toggleOn.toggle()
                    }
                    .animation(.spring(duration: 0.25), value: toggleOn)
                }
                .padding(.top, 50)
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
                        .accentColor(Color(hex: "B4B4B5", transparency: 1))
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
                                        Color(hex: "EB7D7B", transparency: 1)
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
                    HStack {
                        TextHeadline (
                            text: "Daftar Aktivitas",
                            size: 24,
                            color: "Black",
                            transparency: 1.0,
                            weight: "Light"
                        )
                        
                    }
                    HStack {
                        Spacer()
                        Button {
                            isAdd = true
                            activityToEdit = nil
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color(hex: "013C5A", transparency: 1)
                                )
                                .frame(width: 160, height: 40)
                                .overlay(
                                    TextContent(
                                        text: "Tambah Aktivitas",
                                        size: 15,
                                        color: "FBFBFB",
                                        weight: "semibold"
                                    )
                                )
                        }
                    }
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
                            
                            ForEach(Array(filteredActivities.enumerated()),
                                    id: \.offset) { index, activity in
                                HStack {
                                    SettingActivityCard(activity)
                                        .onTapGesture {
                                            self.scheduleManager.addActivity(activity, day: self.day)
                                        }
                                        .overlay(
                                            HStack {
                                                Button {
                                                    self.activitiesManager.removeActivity(index)
                                                } label: {
                                                    Label("", systemImage: "trash")
                                                }
                                                .padding(.leading)
                                                
                                                Spacer()
                                                Button {
                                                    selectedActivity = self.activitiesManager.activities[index]
                                                    showEditActivityView = true
                                                } label: {
                                                    Label("", systemImage: "pencil")
                                                }
                                                .padding(.trailing, viewPortWidth * 0.03)
                                            }, alignment: .leading
                                        )
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
        .sheet(isPresented: $isAdd){
            AddActivityView()
        }
        .sheet(isPresented: $showEditActivityView){
            AddActivityView(activityToEdit: selectedActivity, isEditing: true)
        }
        
    }
  
    
}
