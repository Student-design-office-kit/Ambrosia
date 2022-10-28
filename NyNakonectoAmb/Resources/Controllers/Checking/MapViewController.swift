//
//  MapViewController.swift
//  NyNakonectoAmb
//
//  Created by G412 on 03.03.2022.
//

import UIKit
import WebKit
 
class MapViewController: UIViewController, WKUIDelegate {

    let customAlert = DescriptionAlert()
    var webView: WKWebView!
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://ambros.sfedu.ru/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        NSLayoutConstraint.activate([
                self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
    }
}


