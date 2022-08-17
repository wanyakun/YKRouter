//
//  YKMainTableBarController.swift
//  YKRouter_Example
//
//  Created by wanyakun on 2022/8/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class YKMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    let nowNavVC: UINavigationController = UINavigationController.init(rootViewController: YKNowViewController())
    let forceNavVC: UINavigationController = UINavigationController.init(rootViewController: YKForceViewController())
    let relaxNavVC: UINavigationController = UINavigationController.init(rootViewController: YKRelaxViewController())
    let sleepNavVC: UINavigationController = UINavigationController.init(rootViewController: YKSleepViewController())
    let moveNavVC: UINavigationController = UINavigationController.init(rootViewController: YKMoveViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initTabBar()
    }
    
    func initTabBar() {
        // 背景颜色
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.init(hex: "#9DA1ACFF")], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.init(hex: "#3B3B3BFF")], for: .selected)
        
        if #available(iOS 13.0, *) {
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.init(hex: "#9DA1ACFF")]
            itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.init(hex: "#3B3B3BFF")]
            
            let appearance = UITabBarAppearance()
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            self.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
            } else {
                // Fallback on earlier versions
            }
        }

        // Now
        nowNavVC.tabBarItem.title = "Now"
        nowNavVC.tabBarItem.image = UIImage(named: "tab1")?.withRenderingMode(.alwaysOriginal)
        nowNavVC.tabBarItem.selectedImage = UIImage(named: "tab1_se")?.withRenderingMode(.alwaysOriginal)
        // force
        forceNavVC.tabBarItem.title = "Force"
        forceNavVC.tabBarItem.image = UIImage(named: "tab2")?.withRenderingMode(.alwaysOriginal)
        forceNavVC.tabBarItem.selectedImage = UIImage(named: "tab2_se")?.withRenderingMode(.alwaysOriginal)
        
        // relax
        relaxNavVC.tabBarItem.title = "Relax"
        relaxNavVC.tabBarItem.image = UIImage(named: "tab3")?.withRenderingMode(.alwaysOriginal)
        relaxNavVC.tabBarItem.selectedImage = UIImage(named: "tab3_se")?.withRenderingMode(.alwaysOriginal)
        
        // sleep
        sleepNavVC.tabBarItem.title = "Sleep"
        sleepNavVC.tabBarItem.image = UIImage(named: "tab4")?.withRenderingMode(.alwaysOriginal)
        sleepNavVC.tabBarItem.selectedImage = UIImage(named: "tab4_se")?.withRenderingMode(.alwaysOriginal)
        
        // move
        moveNavVC.tabBarItem.title = "Move"
        moveNavVC.tabBarItem.image = UIImage(named: "tab1")?.withRenderingMode(.alwaysOriginal)
        moveNavVC.tabBarItem.selectedImage = UIImage(named: "tab1_se")?.withRenderingMode(.alwaysOriginal)
        
        
        self.viewControllers = [nowNavVC, forceNavVC, relaxNavVC, sleepNavVC, moveNavVC]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            return false
        }
        
        return true
    }
}

extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        scanner.scanHexInt64(&hexNumber)
        
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255

        self.init(red: r, green: g, blue: b, alpha: a)
        return
    }
}
