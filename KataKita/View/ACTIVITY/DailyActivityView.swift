import AVFoundation
//
//  DailyActivityView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 10/10/24& Edited by Alvito Dwi Heldy Muhammad on 17/10/2024.
//
import SwiftUI

///
struct DailyActivityView: View {
    var parentModeTip: ParentModeTip = ParentModeTip()
    
    @Environment(ScheduleManager.self) private var scheduleManager
    @Environment(ActivitiesManager.self) private var activitiesManager
    @Environment(ProfileViewModel.self) private var viewModel
    @Environment(SecurityManager.self) var securityManager
    @Environment(StateManager.self) private var stateManager
    @Environment(\.dismiss) var dismiss

    @State private var showsettings = false
    @State private var isSetting: Bool = false
    @State private var isRuangan: Bool = false
    @State var toggleOn = false
    @State var isAskPassword = false

    @State private var currentIndex: Int = 0
    @State private var shouldNavigate: Bool = false

    //MARK: viewport size
    let viewPortWidth = UIScreen.main.bounds.width
    let viewPortHeight = UIScreen.main.bounds.height

    var day: Day {
        switch Date().dayNumberOfWeek() {
            case 0: return .SUNDAY
            case 1: return .MONDAY
            case 2: return .TUESDAY
            case 3: return .WEDNESDAY
            case 4: return .THURSDAY
            case 5: return .FRIDAY
            default: return .SATURDAY
        }
    }

    var activities: [Activity] {
        if self.toggleOn {
            return []
        }
        
        let ids = switch self.day {
            case .SUNDAY: self.scheduleManager.schedule.sunday
            case .MONDAY: self.scheduleManager.schedule.monday
            case .TUESDAY: self.scheduleManager.schedule.tuesday
            case .WEDNESDAY: self.scheduleManager.schedule.wednesday
            case .THURSDAY: self.scheduleManager.schedule.thursday
            case .FRIDAY: self.scheduleManager.schedule.friday
            case .SATURDAY: self.scheduleManager.schedule.saturday
        }
        
        var activities = [Activity]()
        
        for id in ids {
            if let activity = self.activitiesManager.activities.first(where: { $0.id == id }) {
                activities.append(activity)
            }
        }
        
        return activities
    }
    
    var steps: [Step] {
        return self.activities[safe: self.stateManager.index]?.sequence ?? []
    }

    var isCompleted: Bool {
        return self.activities.count <= self.stateManager.index
    }
  

    var body: some View {
        let userName = viewModel.userProfile.name.isEmpty ?
                 NSLocalizedString("defaultYou", comment: "Default name for 'you'") :
                 viewModel.userProfile.name

             let localizedActivity = String(format: NSLocalizedString("userActivityKey", comment: ""), userName)

        ZStack {
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    VStack(alignment: .leading) {
                      
                        TextHeadline(
                            text: localizedActivity,
                            size: 36,
                            color: "Black",
                            transparency: 1.0,
                            weight: "Light"
                        )

                        TextContent(
                            text: "Hari \(self.day.toString())",
                            size: 24,
                            color: "Black",
                            transparency: 1.0,
                            weight: "Light"
                        )
                    }
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
                                systemName: self.toggleOn
                                    ? "figure.and.child.holdinghands"
                                    : "figure.child.and.lock.open")
                        }
                        .shadow(
                            color: .black.opacity(0.14), radius: 4,
                            x: 0, y: 2
                        )
                        .popoverTip(parentModeTip, arrowEdge: .top)
                        .tipViewStyle(HeadlineTipViewStyle())
                        .offset(x: self.toggleOn ? 18 : -18)
                        .padding(24)
                        .animation(
                            .spring(duration: 0.25), value: self.toggleOn)
                    }
                    .onTapGesture {
                        if !self.toggleOn {
                            self.isAskPassword = true
                        } else {
                            self.toggleOn.toggle()
                        }
                    }
                    .animation(
                        .spring(duration: 0.25), value: self.toggleOn)
                }
                .padding(.horizontal, 45)
                .frame(height: self.viewPortHeight * 0.15)

                //MARK: - Body
                HStack(alignment: .top, spacing: 45) {
                    if self.isCompleted {
                        Color.clear
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .overlay(
                                TextContent(
                                    text: "Kamu telah menyelesaikan aktivitasmu!",
                                    size: 24,
                                    color: "Black",
                                    transparency: 1.0,
                                    weight: "Light"
                                )
                            )
                    } else {
                        //MARK: viewport kiri (List kegiatan hari ini)
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .center, spacing: 0) {
                                ForEach(
                                    Array(self.activities.enumerated()),
                                    id: \.offset
                                ) { index, activity in
                                    if self.stateManager.index <= index {
                                        ActivityCard(
                                            activity,
                                            size: (self.viewPortWidth * 0.25 - 60, self.viewPortWidth * (180 / 1210.0))
                                        ) {
                                            SpeechManager.shared.speakCardAAC(activity.name)
                                        }
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(hex: "BDD4CE", transparency: self.stateManager.index == index ? 1.0 : 0.0))
                                        )
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                        .scrollDisabled(true)
                        .padding(.vertical, 30)
                        .frame(width: self.viewPortWidth * 0.25)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color(hex: "F7F5F0", transparency: 1.0))
                        )

                        // MARK: Viewport bagian kanan (Tahapan aktivitas)
                        ScrollViewReader { proxy in
                            ZStack(alignment: .trailing) {
                                VStack(alignment: .leading, spacing: 20) {
                                    TextHeadline(
                                        text: "Tahapan aktivitas",
                                        size: 24,
                                        color: "Black",
                                        transparency: 1.0,
                                        weight: "Light"
                                    )
                                    ScrollView {
                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                            ],
                                            spacing: 30
                                        ) {
                                            ForEach(Array(self.steps.enumerated()), id: \.offset) { i, step in
                                                StepCard(
                                                    step,
                                                    size: ((self.viewPortWidth * 0.75 - 290) / 4, self.viewPortWidth * (180 / 1210.0)),
                                                    number: "\(i + 1)"
                                                ) {
                                                    SpeechManager.shared.speakCardAAC(step.description)
                                                }
                                            }
                                        }
                                        .padding(.bottom, 160)
                                    }
                                }
                                .padding(45)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .overlay(
                                    VStack(spacing: 0) {
                                        Spacer()
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(
                                                            hex: "BDD4CE",
                                                            transparency: 0),
                                                        Color(
                                                            hex: "BDD4CE",
                                                            transparency: 1.0),
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom)
                                            )
                                            .frame(height: 60)

                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color(hex: "BDD4CE", transparency: 1.0))
                                            .frame(height: 100)
                                            .overlay(
                                                CustomButtonSide(
                                                    icon: resolveIcon(for: "SELESAI"),
                                                    text: "Selesai",
                                                    width: 250,
                                                    height: 80,
                                                    font: 28,
                                                    iconWidth: 55,
                                                    iconHeight: 55,
                                                    bgColor: "#F7F5F0",
                                                    bgTransparency: 1.0,
                                                    fontColor: "#000000",
                                                    fontTransparency: 1.0,
                                                    cornerRadius: 20,
                                                    isSystemImage: false,
                                                    action: {
                                                        self.stateManager.increment()
                                                        if let activity = self.activities[safe: self.stateManager.index] {
                                                            SpeechManager
                                                                .shared
                                                                .speakCardAAC(activity.name)
                                                        }
                                                        proxy.scrollTo(0, anchor: .top)
                                                    })
                                            )
                                    }
                                )

                                VStack {
                                    CustomButton(
                                        icon: "arrowtriangle.up",
                                        width: 40,
                                        height: 40,
                                        font: 24,
                                        iconWidth: 20,
                                        iconHeight: 20,
                                        bgColor: "000000",
                                        bgTransparency: 0,
                                        fontColor: "#000000",
                                        fontTransparency: self.isCompleted
                                            ? 0.0 : 1.0,
                                        cornerRadius: 20,
                                        isSystemImage: true,

                                        action: {
                                            withAnimation {
                                                let newIndex = max(
                                                    currentIndex - 4, 0)
                                                proxy.scrollTo(
                                                    newIndex, anchor: .top)
                                                currentIndex = newIndex
                                                print(currentIndex)
                                            }
                                        }
                                    )

                                    CustomButton(
                                        icon: "arrowtriangle.down",
                                        width: 40,
                                        height: 40,
                                        font: 24,
                                        iconWidth: 20,
                                        iconHeight: 20,
                                        bgColor: "000000",
                                        bgTransparency: 0,
                                        fontColor: "#000000",
                                        fontTransparency: self.isCompleted
                                            ? 0.0 : 1.0,
                                        cornerRadius: 20,
                                        isSystemImage: true,
                                        action: {
                                            withAnimation {
                                                let stepsCount = steps.count

                                                // Calculate the maximum index allowed
                                                let maxIndex = stepsCount - 1

                                                // Calculate the desired index (move forward by 2)
                                                let calculatedIndex =
                                                    currentIndex + 4

                                                // Ensure the index doesn't exceed the maximum valid index
                                                let newIndex = min(
                                                    calculatedIndex, maxIndex)

                                                // Scroll to the new index in the scroll proxy
                                                proxy.scrollTo(
                                                    newIndex, anchor: .top)

                                                // Update the current index
                                                currentIndex = newIndex
                                                print(currentIndex)
                                            }
                                        }

                                    )

                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color(hex: "BDD4CE", transparency: 1.0))
                            )
                        }
                    }
                }
                .padding(.horizontal, 45)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .opacity(toggleOn ? 0 : 1)
            .rotation3DEffect(
                .degrees(toggleOn ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.easeInOut(duration: 0.5), value: toggleOn)

            AddDailyActivityView(toggleOn: $toggleOn)
            .opacity(toggleOn ? 1 : 0)
            .rotation3DEffect(.degrees(toggleOn ? 0 : -180), axis: (x: 0.0, y: 1.0, z: 0.0))
            .animation(.easeInOut(duration: 0.5), value: toggleOn)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white.ignoresSafeArea())
        .overlay(
            Group {
                if isAskPassword {
                    VStack {
                        SecurityView()
                    }
                    .frame(
                        width: viewPortWidth, height: viewPortHeight + 50
                    )
                    .background(Color.gray.opacity(0.5))
                    .onTapGesture {
                        isAskPassword = false
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
        .onAppear {
            if let activity = self.activities[safe: self.stateManager.index] {
                SpeechManager.shared.speakCardAAC(activity.name)
            }
        }
        .onChange(of: securityManager.isCorrect) {
            if securityManager.isCorrect {
                // Password is correct; toggle and reset values
                toggleOn.toggle()
                isAskPassword = false
                securityManager.isCorrect = false
            }
        }
        .onChange(of: self.toggleOn) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // force self.steps to reevaluate
                
            }
        }
        .onDisappear {
            SpeechManager.shared.stopSpeech()
        }

    }
}
