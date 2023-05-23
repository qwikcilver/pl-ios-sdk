//
//  CardWebViewVC.swift
//  Pliossdk
//
//  Created by Macbook on 23/03/23.
//

import UIKit
import WebKit

@available(iOS 10.0, *)
class CardWebViewVC: UIViewController{
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var webView: WKWebView!
    internal var url: String? = nil
    var mainVC = UIViewController()
    let session = PinePerksSession.sessionPK
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftLoader.show(animated: true)
        self.back.tintColor = UIColor.black
        
        guard let baseUrl = URL(string: url ?? "") else { return }
        var request = URLRequest(url: baseUrl)
        
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if let storedHeader = session.getCardId(), !storedHeader.isEmpty {
            request.setValue(storedHeader, forHTTPHeaderField: "X-PL-SSID")
            webView.load(request)
        } else {
            webView.load(request)
        }
        SwiftLoader.hide()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 10.0, *)
extension CardWebViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(SDKConstants.TAG) Error: (error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url?.absoluteString ?? ""
        var cardSessionId = ""
        if url.contains("/cardDetails") {
            webView.evaluateJavaScript("window.sessionStorage.getItem('CARD_SESSION_ID')", completionHandler: { (result, error) in
                if let value = result as? String {
                    cardSessionId = value
                    self.session.setCardId(cardSessionId)
                }
            })
        } else if url.contains("?c=") {
            session.clearCardId()
        }
    }
}
