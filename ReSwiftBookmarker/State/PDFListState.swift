//
//  PDFListState.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

enum PDFListViewState: Equatable {
    case update
    case comeback(progressLevel: CGFloat, changedPercent: CGFloat)
}

struct PDFListState: StateType {
    var pdfNames: [String] = ["the-great-gatsby", "1984"] // PDF 파일명 목록
    var pdfProgressLevels: [CGFloat] = Array(repeating: 0.0, count: 2) // 읽은 페이지 amount percentage
    var viewState: PDFListViewState = .update // 데이터 변화에 따른 View State
    var onoff: Bool = false
}


