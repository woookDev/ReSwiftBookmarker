//
//  PDFListViewModel.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import Foundation
import ReSwift

/// References from : https://github.com/Alua-Kinzhebayeva/iOS-PDF-Reader

class PDFListViewModel {
    
    var pdfThumbnailViewModels: [PDFThumbnailViewModel] = []
    var pdfProgressLevels: [CGFloat] = []
    
    init() {
        self.pdfThumbnailViewModels = self.populateThumbnailData()
        
        // 원래는 Realm을 사용하려 했으나 사용하지 않게 되면서 초기값을 기억해서 전해주는 store.state.pdfListState.pdfProgressLevels 역할 상실
        self.pdfProgressLevels = store.state.pdfListState.pdfProgressLevels
    }
    
    func thumbnailImageFetch() -> [UIImage]? {
        var images: [UIImage] = []
        for name in store.state.pdfListState.pdfNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
            guard let fileData = try? Data(contentsOf: url) else { return nil }
            
            guard let provider = CGDataProvider(data: fileData as CFData) else { return nil }
            guard let coreDocument = CGPDFDocument(provider) else { return nil }
            
            imageFromPDFPage(document: coreDocument, at: 1) {
                if let image = $0 {
                    images.append(image)
                }
            }
        }
        
        return images
    }
    
    func populateThumbnailData() -> [PDFThumbnailViewModel] {
        var pdfThumbnailViewModels: [PDFThumbnailViewModel] = []
        guard let images = thumbnailImageFetch() else { return [] }
        let progressDatas = store.state.pdfListState.pdfProgressLevels
        for (image, progress) in zip(images, progressDatas) {
            pdfThumbnailViewModels.append(PDFThumbnailViewModel(thumbnail: image, progress: progress))
        }
        
        return pdfThumbnailViewModels
    }
    
    
    
    private func imageFromPDFPage(document: CGPDFDocument, at pageNumber: Int, callback: (UIImage?) -> Void) {
        guard let page = document.page(at: pageNumber) else {
            callback(nil)
            return
        }
        
        let originalPageRect = page.originalPageRect
        
        let scalingConstant: CGFloat = 500
        let pdfScale = min(scalingConstant/originalPageRect.width, scalingConstant/originalPageRect.height)
        let scaledPageSize = CGSize(width: originalPageRect.width * pdfScale, height: originalPageRect.height * pdfScale)
        let scaledPageRect = CGRect(origin: originalPageRect.origin, size: scaledPageSize)
        
        // Create a low resolution image representation of the PDF page to display before the TiledPDFView renders its content.
        UIGraphicsBeginImageContextWithOptions(CGSize(width: originalPageRect.width, height: originalPageRect.height), true, 1)
        guard let context = UIGraphicsGetCurrentContext() else {
            callback(nil)
            return
        }
        
        // First fill the background with white.
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fill(scaledPageRect)
        
        context.saveGState()
        
        // Flip the context so that the PDF page is rendered right side up.
        let rotationAngle: CGFloat
        switch page.rotationAngle {
        case 90:
            rotationAngle = 270
            context.translateBy(x: scaledPageSize.width, y: scaledPageSize.height)
        case 180:
            rotationAngle = 180
            context.translateBy(x: 0, y: scaledPageSize.height)
        case 270:
            rotationAngle = 90
            context.translateBy(x: scaledPageSize.width, y: scaledPageSize.height)
        default:
            rotationAngle = 0
            context.translateBy(x: 0, y: scaledPageSize.height)
        }
        
        context.scaleBy(x: 1, y: -1)
        context.rotate(by: rotationAngle.degreesToRadians)
        
        // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
        context.scaleBy(x: pdfScale, y: pdfScale)
        context.drawPDFPage(page)
        context.restoreGState()
        
        defer { UIGraphicsEndImageContext() }
        guard let backgroundImage = UIGraphicsGetImageFromCurrentImageContext() else {
            callback(nil)
            return
        }
        
        callback(backgroundImage)
    }
}




extension CGPDFPage {
    /// original size of the PDF page.
    var originalPageRect: CGRect {
        switch rotationAngle {
        case 90, 270:
            let originalRect = getBoxRect(.mediaBox)
            let rotatedSize = CGSize(width: originalRect.height, height: originalRect.width)
            return CGRect(origin: originalRect.origin, size: rotatedSize)
        default:
            return getBoxRect(.mediaBox)
        }
    }
}
