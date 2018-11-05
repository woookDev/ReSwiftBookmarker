//
//  PDFDetailAction.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift
import PDFKit

struct SetPDFDetailViewState: Action {
    var viewState: PDFDetailViewState
}

struct SetSelectedPDFIndex: Action {
    var selectedPDFIndex: Int
}

struct SetPageCount: Action {
    var pageCount: Int
}

struct SetPDFDetailData: Action {
    var pdfDetail: PDFDetail
    var selectedPDFIndex: Int
}

