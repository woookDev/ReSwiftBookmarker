//
//  PDFListAction.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

enum SetListViewState: Action {
    case update
    case comeback(progressLevel: CGFloat, changedPercent: CGFloat, selectedPDFIndex: Int)
}


