//
//  PDFBookmarkViewModel.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 29/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

class PDFBookmarkViewModel {
    
    var savedBookmark: [Bookmark] = []
    
    init() {
        self.savedBookmark = store.state.pdfDetailState.pdfDetails[store.state.pdfDetailState.selectedPDFIndex].savedBookmarks
    }
}





