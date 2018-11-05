//
//  PDFListReducer.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

func PDFListReducer(state: PDFListState?, action: Action) -> PDFListState {
    var state = state ?? PDFListState()
    
    switch action {
    case let action as SetListViewState:
        switch action {
        case .update:
            state.viewState = PDFListViewState.update
        case let .comeback(progressLevel, changedPercent, selectedPDFIndex):
            state.pdfProgressLevels[selectedPDFIndex] = progressLevel
            state.viewState = .comeback(progressLevel: progressLevel, changedPercent: changedPercent)
        }
    case let action as ReSwiftInit:
        break
        // Realm을 사용하여 progressLevel을 가져오는 형식으로 하려고 했으나 앱의 기능을 간단히 하기 위해 삭제
    default:
        break
    }
    return state
}



