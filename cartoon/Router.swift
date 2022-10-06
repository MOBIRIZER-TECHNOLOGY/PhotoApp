//
//  Router.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

public final class Router: NSObject {
    public static let shared = Router()
    var navigationController: UINavigationController?
    var image: UIImage? =  nil
    var outPutImage: UIImage? =  nil
    public var currentEffect: Effects = Effects.none
    public var selectedTabIndex: Int = 0
    public func initialize() {
    }
}

