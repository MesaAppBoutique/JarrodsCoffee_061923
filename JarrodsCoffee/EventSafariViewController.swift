//
//  EventSafariViewController.swift
//  JarrodsCoffee
//
//  Created by Mike Bogner on 6/16/23.
//

import UIKit
import WebKit

class EventSafariViewController: UIViewController, WKUIDelegate {
    
    
    var webView: WKWebView!
    
   
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.eventbrite.com/o/jarrods-coffee-amp-art-gallery-51428969283#events")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
