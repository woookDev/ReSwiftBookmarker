//
//  ViewController.swift
//  ReSwiftBookmarker
//
//  Created by 황재욱 on 2018. 10. 26..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit
import ReSwift
import SnapKit
import RxSwift

class PDFListViewController: UIViewController {
    
    var pdfListViewModel: PDFListViewModel!
    
    @IBOutlet weak var readingEncourageImageView: UIImageView!
    @IBOutlet weak var readingEncourageView: UIView!
    @IBOutlet weak var pdfListCollectionView: UICollectionView!
    @IBOutlet weak var readingEncourageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pdfListViewModel = PDFListViewModel()
        self.pdfListCollectionView.register(PDFThumbnailCollectionViewCell.self,
                                            forCellWithReuseIdentifier: String(describing: PDFThumbnailCollectionViewCell.self))
        self.pdfListCollectionView.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) { subscription in
            subscription.select({ state in
                state.pdfListState
            }).skipRepeats({ (a, b) -> Bool in
                return a.viewState == b.viewState
            })
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
}

extension PDFListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // PDF 선택
        store.dispatch(SetSelectedPDFIndex(selectedPDFIndex: indexPath.item))
        let pdfDetailViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PDFDetailViewController")
        self.navigationController?.pushViewController(pdfDetailViewController, animated: true)
    }
}

extension PDFListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pdfListViewModel.pdfThumbnailViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PDFThumbnailCollectionViewCell.self), for: indexPath) as! PDFThumbnailCollectionViewCell
        let data = self.pdfListViewModel.pdfThumbnailViewModels[indexPath.item]
        cell.pdfThumbnailImageView.image = data.thumbnailImage
        cell.progressBar.setProgress(Float(data.progressLevel), animated: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
}

extension PDFListViewController: StoreSubscriber {
    func newState(state: PDFListState) {
        
        switch state.viewState {
        case .update:
            self.view.bringSubviewToFront(self.pdfListCollectionView)
        case let .comeback(progressLevel, changedPercent):
            self.pdfListViewModel.pdfThumbnailViewModels[store.state.pdfDetailState.selectedPDFIndex].progressLevel = progressLevel
            switch changedPercent {
            case ..<0:
                break
            case 0:
                self.readingEncourageView.alpha = 1
                self.view.bringSubviewToFront(self.readingEncourageView)
                UIView.animate(withDuration: 2, animations: {
                    self.readingEncourageView.alpha = 0
                }) { _ in
                    self.view.bringSubviewToFront(self.pdfListCollectionView)
                }
                self.readingEncourageImageView.image = UIImage(named: "Good")
                readingEncourageLabel.text = "한 페이지는 읽자 좀.."
            case 0.001...1.0:
                self.readingEncourageView.alpha = 1
                self.view.bringSubviewToFront(self.readingEncourageView)
                UIView.animate(withDuration: 2, animations: {
                    self.readingEncourageView.alpha = 0
                }) { _ in
                    self.view.bringSubviewToFront(self.pdfListCollectionView)
                }
                self.readingEncourageImageView.image = UIImage(named: "SoGood")
                readingEncourageLabel.text = "오올 꽤 읽었는데?"
            default:
                break
            }
            self.pdfListCollectionView.reloadData()
        default:
            self.view.bringSubviewToFront(self.pdfListCollectionView)
            UIView.animate(withDuration: 0.8) {
                self.view.bringSubviewToFront(self.readingEncourageView)
            }
        }
    }
}

