//
//  PDFDetailViewModel.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 27/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import PDFKit

struct PDFDetailViewModel {
    
    var pdfDetail: PDFDetail
    var pdfDocument: PDFDocument?
    let pdfURL = Bundle.main.url(forResource:
        store.state
            .pdfListState
            .pdfNames[store.state.pdfDetailState.selectedPDFIndex], withExtension: "pdf")
    
    init(isExist: Bool) {
        
        self.pdfDetail = isExist ?  store.state.pdfDetailState
            .pdfDetails[store.state.pdfDetailState.selectedPDFIndex] :
            PDFDetail.init(isLiked: false, lastReadPage: 0, savedBookmarks: [])
    }
}






