//
//  Meme.swift
//  Meme
//
//  Created by osama on 4/26/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
struct Meme {
    var topText : String?
    var botText : String?
    var orgImage : UIImage?
    var finalImage : UIImage?
    init(topText : String?, botText : String?, orgImage : UIImage?, finalImage : UIImage?) {
        self.topText = topText
        self.botText = botText
        self.orgImage = orgImage
        self.finalImage = finalImage
    }
}
