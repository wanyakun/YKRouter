//
//  YKRouterConfig.swift
//  YKRouter
//
//  Created by wanyakun on 2022/8/12.
//

import Foundation

public enum YKRouterFilterType {
    case Pre
    case After
    case Error
}

// MARK: - Protocol
public protocol YKRouterFilterProtocol {
    /// 执行Filter内容，并根据返回结果决定是否继续往下执行，使用url跳转时执行
    @discardableResult
    func runFilter(url: String?, fromVC: UIViewController?, params: [String: Any]?) -> Bool
    /// 执行Filter内容，并根据返回结果决定是否继续往下执行，使用vcName，或者vc跳转时执行
    @discardableResult
    func runFilter(vc: UIViewController?, fromVC: UIViewController?, params: [String: Any]?) -> Bool
    /// 是否执行Filter内容
    func shouldFilter() -> Bool
    /// Filter被执行的优先级，数字越大，优先级越低
    func filterOrder() -> Int
    /// 过滤器类型
    func filterType() -> YKRouterFilterType
}

public class YKRouterConfig  {
    public static let shared = YKRouterConfig()
    
    open var webModuleName: String?
    open var webViewVCName: String?
    open var webViewURLProperty: String?
    
    private var _routerFilters: Array<YKRouterFilterProtocol> = []
    
    public func addRouterFilter(filter: YKRouterFilterProtocol) {
        _routerFilters.append(filter)
        _routerFilters.sort { (filter1: YKRouterFilterProtocol, filter2: YKRouterFilterProtocol) in
            return filter1.filterOrder() < filter2.filterOrder()
        }
    }
    
    public func routerFitlers() -> Array<YKRouterFilterProtocol> {
        return _routerFilters
    }
}
