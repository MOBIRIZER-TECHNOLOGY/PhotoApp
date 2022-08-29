//
//  Router.swift
//  BgEraser
//
//  Created by pawan kumar on 27/08/22.
//

import UIKit

public final class Router: NSObject {
    public static let shared = Router()
    var navigationController: UINavigationController?
    var image: UIImage? =  nil
    var outPutImage: UIImage? =  nil
    public var currentEffect: Effects = Effects.none
   
    public func initialize() {
    }
}

