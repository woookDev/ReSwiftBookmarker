//
//  PDFBookmarkViewController.swift
//  ReSwiftBookmarker
//
//  Created by Jaewook on 27/10/2018.
//  Copyright © 2018 황재욱. All rights reserved.
//

import UIKit
import ReSwift

class PDFBookmarkViewController: UITableViewController {
    
    var pdfBookmarkViewModel: PDFBookmarkViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if store.state.pdfDetailState.pdfDetails.count > store.state.pdfDetailState.selectedPDFIndex {
            self.pdfBookmarkViewModel = PDFBookmarkViewModel()
        }
    }
}

extension PDFBookmarkViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDFBookmarkTableViewCell", for: indexPath)
        guard let date = self.pdfBookmarkViewModel?.savedBookmark[indexPath.row].date,
            let page = self.pdfBookmarkViewModel?.savedBookmark[indexPath.row].page else { return cell }
        
        cell.textLabel?.text = "\(date) \(page)Page"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pdfBookmarkViewModel?.savedBookmark.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let page = self.pdfBookmarkViewModel?
            .savedBookmark[indexPath.row].page else { return }
        
        // ViewState 변경
        store.dispatch(SetPDFDetailViewState(viewState: .showBookmark(page: page)))
        self.navigationController?.popViewController(animated: true)
    }
}
