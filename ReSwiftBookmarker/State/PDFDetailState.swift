//
//  PDFDetailState.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 26/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift
import PDFKit

enum PDFDetailViewState: Equatable {
    case update(page: Int, isLiked: Bool) // 처음 화면이 나오거나 일반적으로 화면이 나올 때 State
    case showBookmark(page: Int) // Bookmark 목록에서 선택한 후 돌아오는 화면 State
}

struct PDFDetailState: StateType {
    var selectedPDFIndex: Int = 0 // 선택된 PDF Index 값
    var pageCount: Int = 0 // 선택된 PDF 총 페이지 값
    var pdfDetails: [PDFDetail] = [PDFDetail.defaultInitiate(), PDFDetail.defaultInitiate()] // Index에 해당하는 PDF의 데이터 배열
    var viewState: PDFDetailViewState = .update(page: 0, isLiked: false) // 데이터 변화에 따른 View State
}






