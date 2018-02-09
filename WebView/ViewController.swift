//
//  ViewController.swift
//  WebView
//
//  Created by James Reeve on 6/2/18.
//  Copyright © 2018 James Reeve. All rights reserved.
//

import UIKit
import WebKit
import ExampleClientLibrary

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    
    //let urlString = "https://secure-uat.amp.com.au/ddc/public/ui/bett3r/"
    let urlString = "https://api-uat.amp.com.au/api/combined/secure/v1/dashboardsummary"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request:CLAlertMessageRequest = CLAlertMessageRequest()
        let response:CLAlertMessageResponse = request.execute()
        print("CL response is: \(response) /n")
        
        urlTextField.delegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("Bearer VOvu3I2lIPKqZC1OyNbA", forHTTPHeaderField: "Authorization")
            request.setValue("James test", forHTTPHeaderField: "x-request-id")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            webView.load(request)
        }
        
        urlTextField.text = urlString
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFieldUrlStr = urlTextField.text, let textFieldUrl = URL(string: textFieldUrlStr) {
            let request = URLRequest(url: textFieldUrl)
            webView.load(request)
        }
        
        //hide keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonClicked(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        if let webViewUrl = webView.url {
//            urlTextField.text = webViewUrl.absoluteString
//        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        if let webViewUrl = webView.url {
            urlTextField.text = webViewUrl.absoluteString
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            if let url = response.url {
                print("Url was: \(url) \n")
            }
            print("Status code is: \(response.statusCode) \n")
            print("Headers are: \(response.allHeaderFields)")
        } else {
            print("Response is not an HTTP response")
        }
        print("Calling decide policy based on webview response! \n")
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load web view content after processing navigation! \n")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to process web view navigation! \n")
    }
}
