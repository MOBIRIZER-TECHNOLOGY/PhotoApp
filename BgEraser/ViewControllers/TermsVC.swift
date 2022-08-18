//
//  TermsVC.swift
//  BgEraser
//
//  Created by Narender Kumar on 08/08/22.
//

import UIKit
import SSCustomSideMenu
import SwiftLoader
import WebKit

class TermsVC: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: SSMenuButton!
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftLoader.show(title: "Loading...", animated: true)
        self.sideMenuBtn.setTitle("", for: .normal)
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: "https://www.google.com")!))
    }
    

}


extension TermsVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftLoader.hide()
    }
    
}
