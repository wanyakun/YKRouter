//
//  YKWebViewController.swift
//  YKRouter_Example
//
//  Created by wanyakun on 2022/8/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class YKWebViewController: UIViewController {
    lazy var webView: WKWebView = WKWebView()
    
    @objc var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = ""
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view).offset(0)
        }
        guard let urlString = url, let uri = URL(string: urlString) else { return }
        webView.load(URLRequest(url: uri))
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "title") {
            if (object is WKWebView && (object as! WKWebView)  === webView) {
                self.navigationItem.title = self.webView.title
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
}
