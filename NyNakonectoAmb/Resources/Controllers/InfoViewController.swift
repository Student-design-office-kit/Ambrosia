//
//  InfoViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 26.08.2022.
//

import UIKit
import PDFKit

class InfoViewController: UIViewController {
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        if let resourceUrl = Bundle.main.url(forResource: fileName, withExtension: "pdf"){
            print ("File's location is \(resourceUrl)")
            return resourceUrl
        }
        return nil
    }
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        
        return pdfView
    }
    
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        if let resourceUrl = self.resourceUrl(forFileName: fileName){
            return PDFDocument(url: resourceUrl)
        }
        return nil
    }
    
    private func displayPdf() {
        let pdfView = self.createPdfView(withFrame: self.view.bounds)
        
        if let pdfDocument = self.createPdfDocument(forFileName: "ambrosiaTrue"){
            self.view.addSubview(pdfView)
            pdfView.document = pdfDocument
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayPdf()
    }
}
