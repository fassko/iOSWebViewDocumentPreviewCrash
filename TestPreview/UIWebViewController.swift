//
//  UIWebViewController.swift
//  TestPreview
//
//  Created by Kristaps Grinbergs on 20/05/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import Foundation
import WebKit

class UIWebViewController: UIViewController {
  private var webView: UIWebView!
  
  private var documentInteractionController: UIDocumentInteractionController?
  private var fileDownloader = FileDownloader()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let htmlFile = Bundle.main.path(forResource: "test", ofType: "html")
    let html = try? String(contentsOfFile: htmlFile!, encoding: .utf8)
    webView.loadHTMLString(html!, baseURL: nil)
    
    fileDownloader.fileDownloaderDelegate = self
  }
  
  override func loadView() {
    webView = UIWebView()
    webView.delegate = self
    view = webView
  }
}

extension UIWebViewController: UIWebViewDelegate {
  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    guard let host = request.url?.host else {
      return true
    }
    
    if host == "download" {
      fileDownloader.downloadFile()
    }
    
    return false
  }
}

extension UIWebViewController: FileDownloaderDelegate {
  func fileDownloaded(url: URL) {
//    DispatchQueue.main.async {
      self.showDocumentPreview(url: url)
//    }
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

extension UIWebViewController: UIDocumentInteractionControllerDelegate {
  func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    return self
  }
}
