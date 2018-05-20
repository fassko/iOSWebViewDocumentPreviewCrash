# Example to show crash when opening UIDocumentInteractionController from web view

This example shows crash when starting to download file via web view - UIWebView and WKWebView.

## WKWebView

Go to `AppDelegate.swift` and change uncomment line with **19** with 

`let viewController = WKWebViewController()`

and comment line **20**

## UIWebView

Go to `AppDelegate.swift` and change uncomment line with **20** with 

`let viewController = UIWebViewController()`

and comment line **19**

## Run the example

1. Run the app
2. Click **Download file** and wait a bit
3. PDF file preview will be shown
4. Click **Download file** again and app will crash

## Fix

Need to execute **UIDocumentInteractionController** `presentPreview` on main thread like:

    DispatchQueue.main.async {
      self.showDocumentPreview(url: url)
    }