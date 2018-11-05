//
//  AppState.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

let store: Store = Store<AppState>(reducer: AppReducer, state: nil)


struct AppState: StateType {
    var pdfListState: PDFListState
    var pdfDetailState: PDFDetailState
}












