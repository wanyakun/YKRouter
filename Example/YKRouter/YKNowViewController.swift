//
//  YKNowViewController.swift
//  YKRouter_Example
//
//  Created by wanyakun on 2022/8/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import YKRouter
import SnapKit

class YKNowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    lazy var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let kCellIndentifier = "CellIdentifier"
    let numOfSection = 4
    let rowsOfSection = [3, 3, 4, 2]
    let titleOfSection = ["present页面", "push页面", "URL跳转", "其他"]
    let titleOfRowInSection = [
        [ "present页面, 默认用法", "present页面, 可选模态，全屏等", "present页面, 提前初始化VC"],
        [ "push页面, 默认用法", "push页面, 提前初始化VC", "push页面, 可选动画，发起页等"],
        [ "URL跳转页面, push", "URL跳转页面, present", "URL跳转页面, present全屏", "URL跳转页面，push带参数"],
        [ "push页面, 打开网页", "直接打开网页"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Now"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view).offset(0)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIndentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleOfSection[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsOfSection[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            YKRouter.shared.present("YKProductListViewController", params: ["productId": "1000123"])
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            YKRouter.shared.present("YKProductListViewController", params: ["productId": "1000123"], modelStyle: 1)
        } else if (indexPath.section == 0 && indexPath.row == 2) {
            let vc = YKRouter.shared.initVC("YKProductListViewController", params: ["productId": "1000123"])
            YKRouter.shared.present(vc)
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            YKRouter.shared.push("YKProductListViewController", params: ["productId": "1000123"])
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            let vc = YKRouter.shared.initVC("YKProductListViewController", params: ["productId": "1000123"])!
            YKRouter.shared.push(vc)
        } else if (indexPath.section == 1 && indexPath.row == 2) {
            let vc = YKRouter.shared.initVC("YKProductListViewController", params: ["productId": "1000123"])!
            YKRouter.shared.push(vc, fromVC: self, animated: false)
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            YKRouter.shared.openUrl("yk://push/YKRouter_Example/YKProductListViewController?productId=100700")
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            YKRouter.shared.openUrl("yk://present/YKRouter_Example/YKProductListViewController?productId=100700")
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            YKRouter.shared.openUrl("yk://fullScreen/YKRouter_Example/YKProductListViewController?productId=100700")
        } else if (indexPath.section == 2 && indexPath.row == 3) {
            YKRouter.shared.openUrl("yk://fullScreen/YKRouter_Example/YKProductListViewController", params: ["productId": "100800"])
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            YKRouter.shared.push("YKWebViewController", params: ["url": "https://m.baidu.com"])
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            YKRouter.shared.openUrl("https://m.baidu.com")
        }
    }
    
    
    //MARK: -UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellIndentifier) else {
            return UITableViewCell(style: .value2, reuseIdentifier: kCellIndentifier)
        }
        cell.accessoryType = .disclosureIndicator
        
        let title = titleOfRowInSection[indexPath.section][indexPath.row]
        cell.textLabel?.text = title
        
        return cell
    }
}
