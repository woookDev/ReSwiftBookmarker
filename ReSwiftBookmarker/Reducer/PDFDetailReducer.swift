//
//  PDFDetailReducer.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

func PDFDetailReducer(state: PDFDetailState?, action: Action) -> PDFDetailState {
    var state = state ?? PDFDetailState()

    switch action {
    case let action as SetSelectedPDFIndex:
        state.selectedPDFIndex = action.selectedPDFIndex
    case let action as SetPageCount:
        state.pageCount = action.pageCount
    case let action as SetPDFDetailData:
        state.pdfDetails.insert(action.pdfDetail, at: action.selectedPDFIndex)
    case let action as SetPDFDetailViewState:
        state.viewState = action.viewState
    default:
        break
    }
    return state
}






