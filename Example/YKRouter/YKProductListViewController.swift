//
//  YKProductListViewController.swift
//  YKRouter_Example
//
//  Created by wanyakun on 2022/8/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class YKProductListViewController: UIViewController {
    
    @objc var productId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Product List"
        self.view.backgroundColor = UIColor.white
        
        let textView = UITextView.init(frame: CGRect.init(x: 120, y: 170, width: 200, height: 80))
        textView.text = productId
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.black
        self.view.addSubview(textView)
        
        let closeButton = UIButton.init(type: .custom)
        closeButton.frame = CGRect.init(x: 100, y: 300, width: 120, height: 40)
        closeButton.layer.cornerRadius = 8
        closeButton.backgroundColor = UIColor.init(hex: "#3C7DFFFF")
        closeButton.setTitle("关闭", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func close() {
        if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
