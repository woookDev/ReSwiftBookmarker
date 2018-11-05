//
//  PDFDetail.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 22/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import PDFKit

struct PDFDetail {
    var isLiked: Bool
    var lastReadPage: Int
    var savedBookmarks: [Bookmark]
    
    static func defaultInitiate() -> PDFDetail {
        return PDFDetail(isLiked: false, lastReadPage: 0, savedBookmarks: [])
    }
}
