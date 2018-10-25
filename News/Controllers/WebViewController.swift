//
//  WebVC.swift
//  News
//
//  Created by Dzmitry Bosak on 9/6/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        setupWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    private func setupWebView() {
        progressView.progress = 0
        
        guard let url = url else {
            return
            
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Observer for progress view
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    // For ProgressView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        
    }
    
    // Actions for buttons
    
    private func openSafari() {
        guard let url = url else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func activityViewController() {
        guard let url = url else {
            return
        }
        
        let urlToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func openSafariButtonPressed(_ sender: Any) {
        openSafari()
    }
    
    @IBAction func actionsButtonPressed(_ sender: Any) {
        activityViewController()
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
}
