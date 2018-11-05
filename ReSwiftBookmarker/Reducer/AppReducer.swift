//
//  AppReducer.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    return AppState(pdfListState: PDFListReducer(state: state?.pdfListState, action: action),
                    pdfDetailState: PDFDetailReducer(state: state?.pdfDetailState, action: action))
}

