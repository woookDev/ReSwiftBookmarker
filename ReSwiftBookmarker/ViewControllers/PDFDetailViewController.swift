//
//  PDFDetailViewController.swift
//  ReSwiftBookmarker
//
//  Created by 황재욱 on 2018. 10. 25..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit
import PDFKit
import ReSwift


extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

class PDFDetailViewController: UIViewController {
   
    var pdfDetailViewModel: PDFDetailViewModel?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastReadPageInitiate()
        loadPDF()
        homeButtonConfigure()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangePdfPage),
                                               name: NSNotification.Name.PDFViewPageChanged,
                                               object: nil)
    }
    
    func homeButtonConfigure() {
        let homeButton = UIBarButtonItem(title: "Home", style: UIBarButtonItem.Style.plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = homeButton

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self) { subscription in
            subscription.select({ state in
                state.pdfDetailState
            }).skipRepeats({ (a, b) -> Bool in
                return a.viewState == b.viewState
            })
        }
    }
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if let isLiked = self.pdfDetailViewModel?.pdfDetail.isLiked, isLiked {
            self.pdfDetailViewModel?.pdfDetail.isLiked = false
            sender.setImage(UIImage(named: "feedGood2X"), for: .normal)
        } else {
            self.pdfDetailViewModel?.pdfDetail.isLiked = true
            sender.setImage(UIImage(named: "feedGoodOrange2X"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        guard let currentPageNumber = self.pdfView.currentPage?.pageRef?.pageNumber else { return }
        
        let newBookMark = Bookmark(date: Date(), page: currentPageNumber)
        self.pdfDetailViewModel?.pdfDetail.savedBookmarks.append(newBookMark)
        
        if let pdfDetail = self.pdfDetailViewModel?.pdfDetail {
            // Redux Store에 저장
            store.dispatch(SetPDFDetailData.init(pdfDetail: pdfDetail,
                                                 selectedPDFIndex: store.state.pdfDetailState.selectedPDFIndex))
        }
    }
    
    
    
    
    @objc func didChangePdfPage() {
        // page 변화할 때마다 Notification
        guard let lastReadPageNumber = pdfView.currentPage?.pageRef?.pageNumber else { return }
        self.pdfDetailViewModel?.pdfDetail.lastReadPage = lastReadPageNumber
    }
    
    @objc func homeButtonTapped(_ sender: UIBarButtonItem) {
        if let pdfDetail = self.pdfDetailViewModel?.pdfDetail {
            store.dispatch(SetPDFDetailData(pdfDetail: pdfDetail,
                                            selectedPDFIndex: store.state.pdfDetailState.selectedPDFIndex))
            
            // 읽은 페이지 퍼센트
            let percentage: CGFloat = CGFloat(pdfDetail.lastReadPage) / CGFloat(store.state.pdfDetailState.pageCount)
            // 지난 번과 비교하여 읽은 변화 퍼센트량
            let changePercentage = percentage - store.state.pdfListState.pdfProgressLevels[store.state.pdfDetailState.selectedPDFIndex]
            
            store.dispatch(SetListViewState.comeback(progressLevel: percentage,
                                                     changedPercent: changePercentage,
                                                     selectedPDFIndex: store.state.pdfDetailState.selectedPDFIndex))
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func lastReadPageInitiate() {
        if store.state.pdfDetailState.pdfDetails.count > store.state.pdfDetailState.selectedPDFIndex {
            self.pdfDetailViewModel = PDFDetailViewModel(isExist: true)
            self.pdfDetailViewModel?.pdfDetail.lastReadPage = store.state.pdfDetailState.pdfDetails[store.state.pdfDetailState.selectedPDFIndex].lastReadPage
            store.dispatch(SetPDFDetailViewState(viewState: PDFDetailViewState.update(page: self.pdfDetailViewModel!.pdfDetail.lastReadPage, isLiked: self.pdfDetailViewModel!.pdfDetail.isLiked)))
        } else {
            self.pdfDetailViewModel = PDFDetailViewModel(isExist: false)
        }
    }
    
    func loadPDF() {
        
        guard let url = self.pdfDetailViewModel?.pdfURL else { return }
        
        let document = PDFDocument(url: url)
        pdfView.document = document
        self.pdfDetailViewModel?.pdfDocument = document
        pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit
        
        if let pageCount = document?.pageCount {
            store.dispatch(SetPageCount(pageCount: pageCount))
        }
        
        if let lastReadPage = self.pdfDetailViewModel?.pdfDetail.lastReadPage, let page = document?.page(at: lastReadPage - 1) {
            pdfView.go(to: page)
        }
    }
}



extension PDFDetailViewController: StoreSubscriber {
    func newState(state: PDFDetailState) {
        switch state.viewState {
        case let .showBookmark(page):
            if let page = self.pdfDetailViewModel?.pdfDocument?.page(at: page - 1) {
                self.pdfView.go(to: page)
            }
        case let .update(page, isLiked):
            if let page = self.pdfDetailViewModel?.pdfDocument?.page(at: page - 1) {
                pdfView.go(to: page)
            }
            if isLiked {
                self.pdfDetailViewModel?.pdfDetail.isLiked = true
                self.likeButton.setImage(UIImage(named: "feedGoodOrange2X"), for: UIControl.State.normal)
            } else {
                self.pdfDetailViewModel?.pdfDetail.isLiked = false
                self.likeButton.setImage(UIImage(named: "feedGood2X"), for: .normal)
            }
        default:
            break
        }
    }
}




