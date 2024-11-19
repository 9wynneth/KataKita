//
//  ParentModeTip.swift
//  KataKita
//
//  Created by Lisandra Nicoline on 19/11/24.
//

import Foundation
import TipKit

struct ParentModeTip: Tip {
    var title: Text {
        Text("")
    }
    
    var message: Text? {
        Text("Dengan menekan tombol ini, Anda dapat menyesuaikan papan AAC sesuai dengan kebutuhan anak Anda.")
    }
    var additionalMessage: Text? {
        Text("")
    }

}

