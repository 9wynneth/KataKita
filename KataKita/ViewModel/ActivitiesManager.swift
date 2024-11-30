//
//  ActivitiesManager.swift
//  KataKita
//
//  Created by Alvito Dwi Reza on 11/10/24.
//

import SwiftUI
import SwiftData

// CRUD for Activity list inside AddDailyActivity Feature

@Observable
class ActivitiesManager {
    private var model: ModelContext
    var activities : [Activity]
    
    init(_ model: ModelContext) {
        self.model = model
        self.activities = []
    }
    
    func load() {
        do {
            let descriptor = FetchDescriptor<Activity>(sortBy: [SortDescriptor(\.id)])
            self.activities = try self.model.fetch(descriptor)
        } catch {
            self.activities = []
        }
    }
    func populate() {
        let datas = [
            Activity(
                name: "Pipis",
                type: .icon("TOILET"),
                sequence: [
                    Step(type: .icon("CELANA PENDEK"), description: "Buka celana"),
                    Step(type: .icon("toilet"), description: "Duduk di toilet"),
                    Step(type: .icon("toilet"), description: "Buang air kecil"),
                    Step(type: .icon("toilet"), description: "Bersihkan daerah kemaluan pakai tisu"),
                    Step(type: .icon("CELANA PENDEK"), description: "Pakai celana kembali"),
                    Step(type: .icon("air"), description: "Siram toilet"),
                    Step(type: .icon("sabun"), description: "Ambil sabun"),
                    Step(type: .icon("cuci tangan"), description: "Cuci tangan dengan sabun"),
                    Step(type: .icon("handuk"), description: "Keringkan tangan")
                ]
            ),
            Activity(
                name: "Makan",
                type: .icon("boy_makan"),
                sequence: [
                    Step(type: .icon("piring"), description: "Ambil piring"),
                    Step(type: .icon("piring sendok"), description: "Ambil sendok dan garpu"),
                    Step(type: .icon("DUDUK DI MEJA BELAJAR"), description: "Duduk di meja makan"),
                    Step(type: .icon("ALKITAB"), description: "Berdoa sebelum makan"),
                    Step(type: .icon("GIRL_MAKAN"), description: "Mulai makan sampai habis"),
                    Step(type: .icon("BOY_MINUM"), description: "Minum air putih setelah makan"),
                    Step(type: .icon("handuk"), description: "Lap mulut setelah habis makan"),
                    Step(type: .icon("PIRING SENDOK"), description: "Kembalikan sendok, garpu, dan piring pada tempatnya")
                ]
            ),
            Activity(
                name: "Cuci Tangan",
                type: .icon("cuci tangan"),
                sequence: [
                    Step(type: .icon("keran"), description: "Buka keran air"),
                    Step(type: .icon("air"), description: "Basahi tangan dengan air"),
                    Step(type: .icon("sabun"), description: "Ambil sabun"),
                    Step(type: .icon("cuci tangan"), description: "Gosok sabun di tangan kiri"),
                    Step(type: .icon("cuci tangan"), description: "Gosok sabun di tangan kanan"),
                    Step(type: .icon("air"), description: "Bilas sabun dengan air"),
                    Step(type: .icon("handuk"), description: "Keringkan tangan")
                ]
            ),
            Activity(
                name: "Cuci Piring",
                type: .icon("piring"),
                sequence: [
                    Step(type: .icon("piring sendok"), description: "Ambil piring dan sendok garpu kotor"),
                    Step(type: .icon("air"), description: "Basahilah dengan air"),
                    Step(type: .icon("sabun"), description: "Ambil spon dan beri sabun"),
                    Step(type: .icon("cuci piring"), description: "Gosok piring dan sendok garpu dengan sabun dan spon"),
                    Step(type: .icon("air"), description: "Bilas semua dengan air bersih"),
                    Step(type: .icon("handuk"), description: "Letakkan di tempat pengeringan")
                ]
            ),
            Activity(
                name: "Mewarnai",
                type: .icon("WARNAI"),
                sequence: [
                    Step(type: .icon("ambil buku"), description: "Ambil buku"),
                    Step(type: .icon("ambil pewarna"), description: "Ambil pewarna"),
                    Step(type: .icon("duduk di meja belajar"), description: "Duduk di meja belajar"),
                    Step(type: .icon("buka buku dan alat pewarna"), description: "Buka buku dan siapkan alat pewarna"),
                    Step(type: .icon("mewarnai"), description: "Mulai mewarnai tugas yang diberikan"),
                    Step(type: .icon("rapikan alat dan buku"), description: "Setelah selesai, rapikan alat mewarnai"),
                    Step(type: .icon("ambil buku"), description: "Kembalikan peralatan pada tempatnya")
                ]
            )
        ]
        
        for data in datas {
            self.model.insert(data)
        }
        guard let _ = try? self.model.save() else {
            return
        }
    }
    
    func addActivity(_ activity: Activity) {
        self.activities.append(activity)
        self.model.insert(activity)
        do {
            try self.model.save()
        } catch {
            print("SAVE ERROR")
        }
    }
    
    func removeActivity(_ index: Int) {
        if(activities.count > index) {
            if let activity = self.activities[safe: index] {
                self.model.delete(activity)
                do {
                    try self.model.save()
                } catch {
                    print("SAVE ERROR")
                }
            }
            self.activities.remove(at: index)
        }
    }
    
    // Update existing activity
    func updateActivity(_ updatedActivity: Activity) {
        if let index = self.activities.firstIndex(where: { $0.id == updatedActivity.id }) {
            self.activities[index] = updatedActivity
            do {
                try self.model.save()
            } catch {
                print("SAVE ERROR")
            }
        }
    }
}
