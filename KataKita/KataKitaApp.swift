//
//  KataKitaApp.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 08/10/24.
//

import SwiftUI
import SwiftData
import TipKit

extension Date {
    func dayNumberOfWeek() -> Int {
        return (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 1) - 1
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : "" as? Self.Element
    }
}

func resolveIcon(for iconName: String) -> String {
    if let _ = UIImage(named: iconName) {
        return iconName
    } else if let _ = UIImage(named: iconName.uppercased()) {
        return iconName.uppercased()
    } else if let _ = UIImage(named: iconName.lowercased()) {
        return iconName.lowercased()
    } else {
        // Fallback option if no icon is found
        return "defaultIcon" // You can define a default icon
    }
}

@main
struct KataKitaApp: App {
    @State private var activityManager = ActivityManager()

    @State private var securityManager = SecurityManager()
    @State private var pecsViewModel = PECSViewModel()
    @State private var aacViewModel = AACViewModel()

    @State private var profileManager = ProfileViewModel()

    @State private var stickerManager = StickerImageManager()
    @State private var originalImageManager = OriginalImageManager()

    let model: ModelContainer
    
    init() {
        guard let model = try? ModelContainer(for: Activity.self, Board.self) else {
            fatalError("Could not create ModelContainer")
        }
        
        self.model = model
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen(self.model.mainContext)
                .task {
                    do {
                        try Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    } catch {
                        print("Error initializing TipKit: \(error.localizedDescription)")
                    }
                }
        }
        .modelContainer(self.model)
        .environment(self.activityManager)
        .environment(self.securityManager)
        .environment(self.pecsViewModel)
        .environment(self.aacViewModel)
        .environment(self.stickerManager)
        .environment(self.originalImageManager)
        .environment(self.profileManager)
    }
}
