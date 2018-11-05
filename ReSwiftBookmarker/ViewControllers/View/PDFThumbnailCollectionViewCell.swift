//
//  PDFThumbnailCollectionViewCell.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 25/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import UIKit
import Then
import SnapKit

class PDFThumbnailCollectionViewCell: UICollectionViewCell {
    
    var pdfThumbnailImageView: UIImageView = {
        let pdfThumbnailImageView = UIImageView()
        return pdfThumbnailImageView
    }()
    
    var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        return progressBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func viewInitConfigure() {
        
        self.do {
            $0.addSubview(pdfThumbnailImageView)
            $0.addSubview(progressBar)
        }
        
        /// ======================= pdfThumbnailImageView
        
        pdfThumbnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(150)
        }
        
        /// ======================= progressBar
        
        progressBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pdfThumbnailImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
            $0.height.equalTo(12)
        }
        
    }
}
