//
//  PrivacyVC.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//


import UIKit
import WebKit

class ChaseRakePrivacyVC: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    //MARK: - Declare IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @objc var url: String?
    let chaseRakePrivacyUrlString = "https://www.termsfeed.com/live/f5b7e6bd-a715-4870-a558-816aa3b3358e"
    
    //MARK: - Declare Variables
    
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chaseRakeInitSubViews()
        chaseRakeInitWebView()
        cardessyStartLoadWebView()
    }
    
    //MARK: - Functions
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    //MARK: - Declare IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func chaseRakeInitSubViews() {
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .black
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .black
        indicatorView.hidesWhenStopped = true
        
        self.backBtn.isHidden = self.url != nil
    }

    private func chaseRakeInitWebView() {
        let userContentC = webView.configuration.userContentController
        
        // afevent
        userContentC.add(self, name: "trackWebEventToAF")
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    private func cardessyStartLoadWebView() {
        let urlStr = url ?? chaseRakePrivacyUrlString
        guard let url = URL(string: urlStr) else { return }
        
        indicatorView.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "trackWebEventToAF" {
            if let dic = message.body as? [String: Any], let event = dic["event"] as? String {
                let da = UserDefaults.standard.value(forKey: "adsData") as? [String] ?? Array()
                if event == da[7], let ur = dic["data"] as? String, let url = URL(string: ur) {
                    UIApplication.shared.open(url)
                } else {
                    chaseRakeLogEvent(event, data: dic["data"] as? [String: Any] ?? Dictionary())
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
        return nil
    }
}
