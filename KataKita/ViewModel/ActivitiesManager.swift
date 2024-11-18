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
                    Step(type: nil, description: "Duduk di toilet"),
                    Step(type: nil, description: "Buang air kecil"),
                    Step(type: nil, description: "Bersihkan daerah kemaluan pakai tisu"),
                    Step(type: nil, description: "Pakai celana kembali"),
                    Step(type: nil, description: "Siram toilet"),
                    Step(type: nil, description: "Ambil sabun"),
                    Step(type: nil, description: "Cuci tangan dengan sabun"),
                    Step(type: nil, description: "Keringkan tangan")
                ]
            ),
            Activity(
                name: "Makan",
                type: .icon("boy_makan"),
                sequence: [
                    Step(type: nil, description: "Ambil piring"),
                    Step(type: nil, description: "Ambil sendok dan garpu"),
                    Step(type: nil, description: "Duduk di meja makan"),
                    Step(type: nil, description: "Berdoa sebelum makan"),
                    Step(type: nil, description: "Mulai makan sampai habis"),
                    Step(type: .icon("MINUM"), description: "Minum air putih setelah makan"),
                    Step(type: nil, description: "Lap mulut setelah habis makan"),
                    Step(type: nil, description: "Kembalikan sendok, garpu, dan piring pada tempatnya")
                ]
            ),
            Activity(
                name: "Cuci Tangan",
                type: .icon("cuci tangan"),
                sequence: [
                    Step(type: .icon("keran"), description: "Buka keran air"),
                    Step(type: nil, description: "Basahi tangan dengan air"),
                    Step(type: nil, description: "Ambil sabun"),
                    Step(type: nil, description: "Gosok sabun di tangan kiri"),
                    Step(type: nil, description: "Gosok sabun di tangan kanan"),
                    Step(type: nil, description: "Bilas sabun dengan air"),
                    Step(type: nil, description: "Keringkan tangan")
                ]
            ),
            Activity(
                name: "Cuci Piring",
                type: .icon("piring"),
                sequence: [
                    Step(type: nil, description: "Ambil piring dan sendok garpu kotor"),
                    Step(type: nil, description: "Basahilah dengan air"),
                    Step(type: nil, description: "Ambil spon dan beri sabun"),
                    Step(type: nil, description: "Gosok piring dan sendok garpu dengan sabun dan spon"),
                    Step(type: nil, description: "Bilas semua dengan air bersih"),
                    Step(type: nil, description: "Letakkan di tempat pengeringan"),
                    Step(type: nil, description: "Basahilah dengan air"),
                    Step(type: nil, description: "Ambil spon dan beri sabun"),
                    Step(type: nil, description: "Gosok piring dan sendok garpu dengan sabun dan spon"),
                    Step(type: nil, description: "Bilas semua dengan air bersih"),
                    Step(type: nil, description: "Letakkan di tempat pengeringan")
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
                    Step(type: .icon("kembalikan ke tempat asalnya"), description: "Kembalikan peralatan pada tempatnya")
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
