//
//  PDFThumbnailViewModel.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import UIKit

class PDFThumbnailViewModel {
    
    var thumbnailImage: UIImage
    var progressLevel: CGFloat
    
    init(thumbnail image: UIImage, progress: CGFloat) {
        self.thumbnailImage = image
        self.progressLevel = progress
    }
}
