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
    var stickerImage: URL?

    // Fungsi untuk mengosongkan stickerImage
    func clearStickerImage() {
        stickerImage = nil
    }
}

@Observable
class OriginalImageManager {
    var imageFromLocal: URL?

    // Fungsi untuk mengosongkan imageFromLocal
    func clearImageFromLocal() {
        imageFromLocal = nil
    }
}
