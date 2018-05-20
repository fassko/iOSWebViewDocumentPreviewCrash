//
//  FileDownloader.swift
//  dashboard
//
//  Created by Kristaps Grinbergs on 16/04/2018.
//  Copyright © 2018 Qminder. All rights reserved.
//

import Foundation
import UIKit

protocol FileDownloaderDelegate: AnyObject {
  func fileDownloaded(url: URL)
  func failed(error: Error)
}

struct FileDownloader {
  internal weak var fileDownloaderDelegate: FileDownloaderDelegate?
  
  private let filePath = "https://s1.q4cdn.com/806093406/files/doc_downloads/test.pdf"
  
  func downloadFile() {
    let url = URL(string: filePath)
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
    URLSession.shared.downloadTask(with: request) { tempLocalUrl, _, error in
      if let error = error {
        self.fileDownloaderDelegate?.failed(error: error)
      } else if let tempLocalUrl = tempLocalUrl {
        do {
          
          let fileManager = FileManager.default
          let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
          
          let timestamp = ((Date().timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
          let finalURL = documentsUrl.first!.appendingPathComponent("\(timestamp).pdf")
          try FileManager.default.copyItem(at: tempLocalUrl, to: finalURL)
          self.fileDownloaderDelegate?.fileDownloaded(url: finalURL)

        } catch let error {
          self.fileDownloaderDelegate?.failed(error: error)
        }
      }
    }.resume()
  }
}
