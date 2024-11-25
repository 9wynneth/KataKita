//
//  ParentModeTip.swift
//  KataKita
//
//  Created by Lisandra Nicoline on 19/11/24.
//

import Foundation
import TipKit

struct ParentModeTip: Tip {
    let localizedName = NSLocalizedString("Dengan menekan tombol ini, Anda dapat menyesuaikan papan AAC sesuai dengan kebutuhan anak Anda.", comment: "Concatenated text for speech synthesis")
    
    var title: Text {
        Text("")
    }
    var message: Text? {
        Text("\(localizedName)")
    }
    var additionalMessage: Text? {
        Text("")
    }

}

struct ParentModeTipPECS: Tip {
    let localizedName = NSLocalizedString("Dengan menekan tombol ini, Anda dapat menyesuaikan PECS sesuai dengan kebutuhan anak Anda.", comment: "Concatenated text for speech synthesis")
    
    var title: Text {
        Text("")
    }
    var message: Text? {
        Text("\(localizedName)")
    }
    var additionalMessage: Text? {
        Text("")
    }

}

struct ParentModeTipSchedule: Tip {
    let localizedName = NSLocalizedString("Dengan menekan tombol ini, Anda dapat menyesuaikan jadwal sesuai dengan kebutuhan anak Anda.", comment: "Concatenated text for speech synthesis")
    
    var title: Text {
        Text("")
    }
    var message: Text? {
        Text("\(localizedName)")
    }
    var additionalMessage: Text? {
        Text("")
    }

}

