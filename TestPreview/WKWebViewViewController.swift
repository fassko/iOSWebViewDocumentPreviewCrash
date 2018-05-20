//
//  WKWebViewController.swift
//  TestPreview
//
//  Created by Kristaps Grinbergs on 09/05/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
  
  private var webView: WKWebView!
  
  private var documentInteractionController: UIDocumentInteractionController?
  private var fileDownloader = FileDownloader()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let htmlPath = Bundle.main.path(forResource: "test", ofType: "html")
    let folderPath = Bundle.main.bundlePath
    let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
    do {
      let htmlString = try NSString(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
      webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
    } catch {
      print(error)
    }
    
    fileDownloader.fileDownloaderDelegate = self
  }
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
}

extension WKWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    guard let host = navigationAction.request.url?.host else {
      decisionHandler(.allow)
      return
    }
    
    if host == "download" {
      fileDownloader.downloadFile()
    }
    
    decisionHandler(.cancel)
  }
}

extension WKWebViewController: FileDownloaderDelegate {
  func fileDownloaded(url: URL) {
    
    print(Thread.isMainThread)
    print(Thread.current)
    
    DispatchQueue.main.async {
      self.showDocumentPreview(url: url)
    }
  }
  
  func failed(error: Error) {
    print(error)
  }
  
  private func showDocumentPreview(url: URL) {
    self.documentInteractionController = UIDocumentInteractionController(url: url)
    self.documentInteractionController?.delegate = self
    self.documentInteractionController?.presentPreview(animated: true)
  }
}

extension WKWebViewController: UIDocumentInteractionControllerDelegate {
  func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    return self
  }
}
