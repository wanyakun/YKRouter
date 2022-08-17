//
//  YKRouter.swift
//  YKRouter
//
//  Created by wanyakun on 2022/8/12.
//

import Foundation
import UIKit

// MARK: -- 单例
public class YKRouter {
    public static let shared = YKRouter()
    private init() {}
}

// MARK: -- 对象初始化
extension YKRouter {
    
    /// VC初始化并赋值参数
    /// - Parameters:
    ///   - vcName: vc名称
    ///   - moduleName: 组件bundle名称，不传则为默认命名空间
    ///   - params: 参数字典，由于为KVC赋值，必须在参数上标记 @objc
    /// - Returns: UIViewController实例
    @discardableResult
    public func initVC(_ vcName: String, moduleName: String? = nil, params: [String: Any]? = nil) -> UIViewController? {
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(vcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIViewController.Type else {
            return nil
        }
        let controller = vc.init()
        setObjectParams(obj: controller, params: params)
        return controller
    }
    
    public func initObjc(_ objcName: String, moduleName: String? = nil, params: [String: Any]? = nil) -> NSObject? {
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(objcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let ob = cls as? NSObject.Type else {
            return nil
        }
        let objc = ob.init()
        setObjectParams(obj: objc, params: params)
        return objc
    }
}

// MARK: -- 属性检查
extension YKRouter {
    
    /// 判断属性是否存在
    /// - Parameters:
    ///   - name: 属性名称
    ///   - obj: 目标对象
    /// - Returns: 是否存在
    private func getTypeOfProperty(_ name: String, obj: AnyObject) -> Bool {
        let mirror = Mirror(reflecting: obj)
        let superMirror = Mirror(reflecting: obj).superclassMirror
        
        for (key, _) in mirror.children {
            if key == name {
                return true
            }
        }
        
        guard let superM = superMirror else {
            return false
        }
        
        for (key, _) in superM.children {
            if key == name {
                return true
            }
        }
        
        return false
    }
    
    
    /// KVC给属性赋值
    /// - Parameters:
    ///   - obj: 目标对象
    ///   - params: 参数字典key必须为属性名
    private func setObjectParams(obj: AnyObject, params: [String: Any]?) {
        if let params = params {
            for (key, value) in params {
                if getTypeOfProperty(key, obj: obj) {
                    obj.setValue(value, forKey: key)
                }
            }
        }
    }
    
}

// MARK: -- 路由原生跳转
extension YKRouter {
    
    /// 路由Push
    /// - Parameters:
    ///   - vcName: 目标vcName
    ///   - moduleName: 目标vc所在组件名称
    ///   - fromVC: 从那个页面起跳，不传默认取最上层VC
    ///   - params: 参数字典
    ///   - animated: 是否有动画
    public func push(_ vcName: String, moduleName: String? = nil, fromVC: UIViewController? = nil, params: [String: Any]? = nil, animated: Bool = true) {
        guard let vc = initVC(vcName, moduleName: moduleName, params: params) else {
            executeErrorFilters(vc: nil, fromVC: fromVC, params: params)
            return
        }
        // 执行前置过滤器
        if executePreFilters(vc: vc, fromVC: fromVC, params: params) == false {
            return
        }
        push(vc: vc, fromVC: fromVC, animated: animated)
    }
    
    
    /// 路由Push，提前初试好VC
    /// - Parameters:
    ///   - vc: 已经初始化好的VC对象
    ///   - fromVC: 从那个页面起跳，不传默认取最上层VC
    ///   - animated: 是否有动画
    public func push(_ vc: UIViewController?, fromVC: UIViewController? = nil, animated: Bool = true) {
        guard let vc = vc else {
            executeErrorFilters(vc: vc, fromVC: fromVC, params: nil)
            return
        }
        // 执行前置过滤器
        if executePreFilters(vc: vc, fromVC: fromVC, params: nil) == false {
            return
        }
        push(vc: vc, fromVC: fromVC, animated: animated)
    }
    
    /// 路由Push，提前初试好VC
    /// - Parameters:
    ///   - vc: 已经初始化好的VC对象
    ///   - fromVC: 从那个页面起跳，不传默认取最上层VC
    ///   - animated: 是否有动画
    fileprivate func push(vc: UIViewController, fromVC: UIViewController?, animated: Bool = true) {
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            currentViewController()?.navigationController?.pushViewController(vc, animated: animated)
            executeAfterFilters(vc: vc, fromVC: fromVC, params: nil)
            return
        }
        from.navigationController?.pushViewController(vc, animated: animated)
        executeAfterFilters(vc: vc, fromVC: fromVC, params: nil)
    }
    
    
    /// 路由Present
    /// - Parameters:
    ///   - vcName: 目标vc名称
    ///   - moduleName: 目标vc所在组件名称
    ///   - fromVC: 从哪个页面起跳，默认取最上层vc
    ///   - params: 参数
    ///   - needNav: 是否需要导航栏（原生导航栏,如需要自定义导航栏请直接传递相应的带导航栏VC对象）
    ///   - modelStyle: 模态样式， 0:为默认，1:全屏模态，2:custom
    ///   - animated: 是否有动画，默认为true
    public func present(_ vcName: String, moduleName: String? = nil, fromVC: UIViewController? = nil, params: [String: Any]? = nil, needNav: Bool = false, modelStyle: Int = 0, animated: Bool = true) {
        guard let vc = initVC(vcName, moduleName: moduleName, params: params) else {
            executeErrorFilters(vc: nil, fromVC: fromVC, params: params)
            return
        }
        // 执行前置过滤器
        if executePreFilters(vc: vc, fromVC: fromVC, params: params) == false {
            return
        }
        present(vc: vc, fromVC: fromVC, needNav: needNav, modelStyle: modelStyle, animated: animated)
    }
    
    
    /// 路由Present，目标vc提前初始化好
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象,可传递Nav对象(自定义导航栏的)
    ///   - fromVC: 从哪个页面起跳，默认取最上层vc
    ///   - needNav: 是否需要导航栏（原生导航栏,如需要自定义导航栏请直接传递相应的带导航栏VC对象）
    ///   - modelStyle: 模态样式， 0:为默认，1:全屏模态，2:custom
    ///   - animated: 是否有动画，默认为true
    public func present(_ vc: UIViewController?, fromVC: UIViewController? = nil, needNav: Bool = false, modelStyle: Int = 0, animated: Bool = true) {
        guard let vc = vc else {
            executeErrorFilters(vc: vc, fromVC: fromVC, params: nil)
            return
        }
        present(vc: vc, fromVC: fromVC, needNav: needNav, modelStyle: modelStyle, animated: animated)
    }
    
    
    /// 路由Present，目标vc提前初始化好
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象,可传递Nav对象(自定义导航栏的)
    ///   - fromVC: 从哪个页面起跳，默认取最上层vc
    ///   - needNav: 是否需要导航栏（原生导航栏,如需要自定义导航栏请直接传递相应的带导航栏VC对象）
    ///   - modelStyle: 模态样式， 0:为默认，1:全屏模态，2:custom
    ///   - animated: 是否有动画，默认为true
    fileprivate func present(vc: UIViewController, fromVC: UIViewController? = nil, needNav: Bool = false, modelStyle: Int = 0, animated: Bool = true) {
        var target = vc
        
        if needNav {
            target = UINavigationController(rootViewController: vc)
        }
        
        switch modelStyle {
        case 1:
            target.modalPresentationStyle = .fullScreen
            break
        case 2:
            target.modalPresentationStyle = .custom
            break
        default:
            if #available(iOS 13.0, *) {
                target.modalPresentationStyle = .automatic
            } else {
                target.modalPresentationStyle = .fullScreen
            }
        }
        
        guard let from = fromVC else {
            currentViewController()?.present(target, animated: animated, completion: {
                self.executeAfterFilters(vc: vc, fromVC: fromVC, params: nil)
            })
            return
        }
        from.present(target, animated: animated) {
            self.executeAfterFilters(vc: vc, fromVC: fromVC, params: nil)
        }
    }
}

// MARK: -- URL路由跳转
extension YKRouter {
    
    /// URL路由跳转 跳转区分push、present、fullScreen
    /// - Parameters:
    ///   - urlString: urlString:调用原生页面功能 scheme ://push/moduleName/vcName?quereyParams， 此处注意编进URL的字符串不能出现特殊字符,要进行URL编码,不支持quereyParams参数有url然后url里还有querey(如果非要URL带token这种情况拦截一下使用路由代码跳转)
    ///   - params: 自定义参数
    public func openUrl(_ urlString: String?, params: [String: Any]? = nil) {
        guard let str = urlString, let url = URL(string: str) else {
            executeErrorFilters(url: urlString, params: params)
            return
        }
        // 执行前置过滤器
        if executePreFilters(url: urlString, params: params) == false {
            return
        }
        
        // 计算参数
        var targetParams = (url.queryDictionary ?? [:]).merging(params ?? [:], uniquingKeysWith: { _, second in
            return second
        })
        
        if url.scheme!.hasPrefix("http") {
            // 打开网页
            guard let vcName = YKRouterConfig.shared.webViewVCName, let moduleName = YKRouterConfig.shared.webModuleName, let urlProperty = YKRouterConfig.shared.webViewURLProperty else {
                executeErrorFilters(url: urlString, params: params)
                return
            }
            targetParams[urlProperty] = urlString
            
            if (currentViewController()?.navigationController != nil) {
                push(vcName, moduleName: moduleName, params: targetParams)
            } else {
                present(vcName, moduleName: moduleName, params: targetParams)
            }
        } else {
            let path = url.path
            let startIndex = path.index(path.startIndex, offsetBy: 1)
            let pathArray = path.suffix(from: startIndex).components(separatedBy: "/")
            guard pathArray.count == 2, let moduleName = pathArray.first, let vcName = pathArray.last else {
                executeErrorFilters(url: urlString, params: params)
                return
            }

            switch url.host {
            case "present":
                present(vcName, moduleName: moduleName, params: targetParams)
            case "fullScreen":
                present(vcName, moduleName: moduleName, params: targetParams, modelStyle: 1)
            default:
                push(vcName, moduleName: moduleName, params: targetParams)
            }
        }
    }
}

// MARK: -- 执行Filter
extension YKRouter {
    private func executePreFilters(url: String?, fromVC: UIViewController? = nil, params: [String: Any]? = nil) -> Bool {
        var result = true
        for filter in YKRouterConfig.shared.routerFitlers() {
            if (filter.filterType() == .Pre) {
                result = filter.runFilter(url: url, fromVC: fromVC, params: params)
                if (result == false) {
                    break
                }
            }
        }
        return result
    }
    
    private func executePreFilters(vc: UIViewController, fromVC: UIViewController? = nil, params: [String: Any]? = nil) -> Bool {
        var result = true
        for filter in YKRouterConfig.shared.routerFitlers() {
            if (filter.filterType() == .Pre) {
                result = filter.runFilter(vc: vc, fromVC: fromVC, params: params)
                if (result == false) {
                    break
                }
            }
        }
        return result
    }
    
    private func executeAfterFilters(vc: UIViewController, fromVC: UIViewController? = nil, params: [String: Any]? = nil) {
        for filter in YKRouterConfig.shared.routerFitlers() {
            if (filter.filterType() == .After) {
                filter.runFilter(vc: vc, fromVC: fromVC, params: params)
            }
        }
    }
    
    
    private func executeErrorFilters(url: String?, fromVC: UIViewController? = nil, params: [String: Any]? = nil) {
        for filter in YKRouterConfig.shared.routerFitlers() {
            if (filter.filterType() == .Error) {
                filter.runFilter(url: url, fromVC: fromVC, params: params)
            }
        }
    }
    
    private func executeErrorFilters(vc: UIViewController?, fromVC: UIViewController? = nil, params: [String: Any]? = nil) {
        for filter in YKRouterConfig.shared.routerFitlers() {
            if (filter.filterType() == .Error) {
                filter.runFilter(vc: vc, fromVC: fromVC, params: params)
            }
        }
    }
}

// MARK: -- 获取最上层视图
extension YKRouter {
    public func currentViewController() -> UIViewController? {
        var vc: UIViewController?
        if (strcmp(__dispatch_queue_get_label(nil), __dispatch_queue_get_label(DispatchQueue.main)) == 0) {
            vc = _currentViewController()
        } else {
            let semaphore = DispatchSemaphore.init(value: 0)
            DispatchQueue.main.async {
                vc = self._currentViewController()
                semaphore.signal()
            }
            semaphore.wait()
        }
        return vc
    }
    
    
    private func _currentViewController() -> UIViewController? {
        var vc = appWindow()?.rootViewController
        while (vc != nil) {
            if (vc is UITabBarController) {
                vc = (vc as! UITabBarController).selectedViewController
            } else if (vc is UINavigationController) {
                vc = (vc as! UINavigationController).topViewController
            } else if (vc?.presentedViewController != nil) {
                vc = vc?.presentedViewController
            } else if (vc is UISplitViewController && (vc as! UISplitViewController).viewControllers.count > 0) {
                vc = (vc as! UISplitViewController).viewControllers.last
            } else {
                return vc
            }
        }
        return vc
    }
    
    public func appWindow() -> UIWindow? {
        var window: UIWindow?
        if (strcmp(__dispatch_queue_get_label(nil), __dispatch_queue_get_label(DispatchQueue.main)) == 0) {
            window = _appWindow()
        } else {
            let semaphore = DispatchSemaphore.init(value: 0)
            DispatchQueue.main.async {
                window = self._appWindow()
                semaphore.signal()
            }
            semaphore.wait()
        }
        return window
    }
    
    private func _appWindow() -> UIWindow? {
        var window = UIApplication.shared.windows[0]
        if window.windowLevel != UIWindow.Level.init(0.0) {
            let windows = UIApplication.shared.windows
            for tWindow in windows {
                if tWindow.windowLevel == UIWindow.Level.init(0.0) {
                    window = tWindow
                    break
                }
            }
        }
        return window
    }

}

// MARK: -- 从URL中获取字典
public extension NSObject {
    func moduleName() -> String {
        let name = type(of: self).description()
        guard let module: String = name.components(separatedBy: ".").first else {
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        }
        return module
    }
}

public extension URL {
    var queryDictionary: [String: Any]? {
        guard let query = self.query else { return nil }
        
        var dict = [String: String]()
        for kvPair in query.components(separatedBy: "&") {
            let pair = kvPair.components(separatedBy: "=")
            if (pair.count == 2) {
                let key = pair[0]
                let value = pair[1].replacingOccurrences(of: "+", with: "%20").removingPercentEncoding ?? ""
                dict[key] = value
            }
        }
        return dict
    }
}

