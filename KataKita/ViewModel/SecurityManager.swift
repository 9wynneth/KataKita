//
//  SecurityManager.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 05/11/24.
//

import SwiftUI

@Observable
class SecurityManager {
    var isCorrect: Bool = false
}

@Observable
class StickerImageManager {
     var stickerImage: Data?

    // Fungsi untuk mengosongkan stickerImage
    func clearStickerImage() {
        stickerImage = nil
    }
    func getStickerImage() -> Data? {
           return stickerImage
       }
}

@Observable
class OriginalImageManager {
     var imageFromLocal: Data?

    // Fungsi untuk mengosongkan imageFromLocal
    func clearImageFromLocal() {
        imageFromLocal = nil
    }
}
