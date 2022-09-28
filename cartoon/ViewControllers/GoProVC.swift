//
//  GoProVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import StoreKit
import SwiftyStoreKit

enum GoProSubscribeMode {
    case none
    case week
    case year
    
    func getSting() -> String {
        switch self {
        case .none:
            return ""
        case .week:
            return InAppProduct.ONE_WEEK
        case .year:
            return InAppProduct.ONE_YEAR
        }
    }
}


class GoProVC: BaseVC {
    
    @IBOutlet weak var proLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedGoProSubscribeMode: GoProSubscribeMode = .none
    let products: Set<String> = [InAppProduct.ONE_WEEK, InAppProduct.ONE_YEAR]
    var productList: [SKProduct]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        proLbl.layer.cornerRadius = 13.0
        proLbl.clipsToBounds = true
        
        self.retrieveAllProducts()
    }
    
    func retrieveAllProducts() {
        SwiftyStoreKit.retrieveProductsInfo(products) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                
                for p in result.retrievedProducts {
                    self.productList.append(p)
                }
                self.tableView.reloadData()
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    func purchaseProduct(productString: String, completionHandler: @escaping (_ productDetail: PurchaseDetails?, _ errorMsg: String?) -> Void) {
        SwiftyStoreKit.purchaseProduct(productString, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                completionHandler(purchase, nil)
            case .error(let error):
                switch error.code {
                case .unknown:
                    completionHandler(nil, "Unknown error. Please contact support")
                case .clientInvalid:
                    completionHandler(nil,"Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid:
                    completionHandler(nil,"The purchase identifier was invalid")
                case .paymentNotAllowed:
                    completionHandler(nil,"The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    completionHandler(nil,"The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    completionHandler(nil,"Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    completionHandler(nil,"Could not connect to the network")
                case .cloudServiceRevoked:
                    completionHandler(nil,"User has revoked permission to use this cloud service")
                default: completionHandler(nil,(error as NSError).localizedDescription)
                }
            }
        }
        
    }
    
    
    @IBAction func upgradeAction(_ sender: UIButton) {
        if selectedGoProSubscribeMode == .none  {
            self.showAlertWithOk(title: "Toon App", message: "Please select any product")
        } else {
            let productID = (selectedGoProSubscribeMode == .week) ? GoProSubscribeMode.week.getSting() : GoProSubscribeMode.year.getSting()
            self.purchaseProduct(productString: productID) { productDetail, errorMsg in
                if productDetail != nil {
                    // TODO: Product buy
                }  else {
                    print(errorMsg ?? "Error in buy item")
                    self.showAlertWithOk(title: "Toon App", message: errorMsg ?? "Error in buy item")
                }
            }
        }
    }
    
}


extension GoProVC :  UITableViewDelegate,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //DetailCell
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "GoProDetailCell", for: indexPath) as? GoProDetailCell
            cell?.delegate = self
            return cell ?? UITableViewCell()
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UpgradeCell", for: indexPath)
            return cell
        }
    }
    
}


extension GoProVC: GoProDetailCellDelegate {
    
    func selectedGoProPlanitem(_ idx: Int) {
        if idx == 10 {
            // 1 week
            selectedGoProSubscribeMode = .week
        } else {
            // 1 year
            selectedGoProSubscribeMode = .year
        }
    }
    
}
