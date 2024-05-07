//
//  SKStore.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/17.
//


import MerchantKit
import StoreKit

public enum SKPurchaseResult {
    case success
    case cancel
    case error
}

public class SKStore {
    
    public static let subscriptionSuccessNotification = NSNotification.Name("kSubscriptionSuccessNotification")
    public static let subscriptionStateDidChangeNotification = NSNotification.Name("kSubscriptionStateDidChangeNotification")
    
    public static let shared = SKStore()
    private var merchant: Merchant!
    private var products: [MerchantKit.Product]?
    private var purchaseSet: PurchaseSet?
    
    public func isPurchased(_ identifier: String) -> Bool {
        guard let product = merchant.product(withIdentifier: identifier) else {
            return false
        }

        let state = merchant.state(for: product)
        switch state {
        case .unknown:
            return false
        case .notPurchased:
            return false
        case .isPurchased(let purchasedProductInfo):
            guard let expiryDate = purchasedProductInfo.expiryDate else  {
                return false
            }
            return Date().compare(expiryDate) == .orderedAscending
        }
    }
    
    public func purchase(for identifier: String) -> Purchase? {
        guard let product = merchant.product(withIdentifier: identifier) else {
            return nil
        }
        
        return purchaseSet?.purchase(for: product)
    }
    
    init() {
        self.merchant = Merchant(configuration: .default, delegate: self)
        
    }
    
    public func register(_ identifiers: Set<String>) {
        let products = identifiers.map { identifier in
            Product(identifier: identifier, kind: .subscription(automaticallyRenews: true))
        }
        self.products = products
        merchant.register(products)
        merchant.setup()
        fetchPurchases()
    }
    
    public func fetchPurchases(with completion: (() -> Void)? = nil) {
        let availableTask = merchant.availablePurchasesTask()
        availableTask.onCompletion = { result in
            if case let .success(purchases) = result {
                self.purchaseSet = purchases
            }
            completion?()
        }
        availableTask.start()
    }
    
    public func purchaseProduct(_ identifier: String, completion: @escaping (SKPurchaseResult) -> Void) {
        guard let product = merchant.product(withIdentifier: identifier) else {
            completion(.error)
            return
        }
        
        if let purchase = purchaseSet?.purchase(for: product) {
            p_purchase(with: purchase, completion: completion)
            return
        }
        
        let availableTask = merchant.availablePurchasesTask(for: [product])
        availableTask.onCompletion = { result in
            switch result {
            case .success(let purchases):
                if let purchase = purchases.first(where: { $0.productIdentifier == identifier}) {
                    self.p_purchase(with: purchase, completion: completion)
                } else {
                    completion(.error)
                }
                
            case .failure(_):
                completion(.error)
            }
        }
        availableTask.start()
    }
    
    private func p_purchase(with purchase: Purchase, completion: @escaping (SKPurchaseResult) -> Void) {
        let purchasesTask = self.merchant.commitPurchaseTask(for: purchase)
        purchasesTask.onCompletion = { purchaseResult in
            switch purchaseResult {
            case .success(_):
                NotificationCenter.default.sk_post(name: SKStore.subscriptionSuccessNotification)
                completion(.success)
            case .failure(_):
                completion(.error)
            }
        }
        purchasesTask.start()
    }
    
    public func restorePurchases(_ completion: @escaping (SKPurchaseResult) -> Void) {
        let restoreTask = merchant.restorePurchasesTask()
        restoreTask.onCompletion = { retult in
            switch retult {
            case .success(_):
                NotificationCenter.default.sk_post(name: SKStore.subscriptionSuccessNotification)
                completion(.success)
            case .failure(_):
                completion(.error)
            }
        }
        restoreTask.start()
    }
}


extension SKStore : MerchantDelegate {
    public func merchant(_ merchant: Merchant, didChangeStatesFor products: Set<MerchantKit.Product>) {
        NotificationCenter.default.sk_post(name: SKStore.subscriptionStateDidChangeNotification)
    }
    public func merchantDidChangeLoadingState(_ merchant: Merchant) {
        
    }
}

public extension SKStore {
    static func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

//import Foundation
//import SwiftyStoreKit
//import StoreKit
//
//
//public enum SKRetrieveResults {
//    case success(Set<SKProduct>)
//    case error
//}
//
//private let kSharedSecret = "85465e14cdc94fe4afb4a40d830fc87a"
//
//public class SKStore {
//    
//    var isSubscriptionActive: Bool {
//        // 获取本地的App Store购买凭据
//        guard let receiptURL = Bundle.main.appStoreReceiptURL,
//              let receiptData = try? Data(contentsOf: receiptURL) else {
//            return false
//        }
//
//        let request = SKReceiptRefreshRequest(receiptProperties: nil)
//        request.start() { (request, error) in
//            guard error == nil else {
//                print("刷新凭据失败: \(error!.localizedDescription)")
//                return
//            }
//
//            // 在本地验证购买凭据
//            do {
//                let receipt = try ReceiptValidator.validate(receipt: receiptData)
//                // 在receipt中检查用户的订阅状态
//                // 例如，检查最新订阅的到期时间，或者验证订阅是否处于有效状态等
//                if userIsSubscribed(receipt: receipt) {
//                    // 用户已经订阅，执行相应的操作
//                    print("用户已订阅")
//                } else {
//                    // 用户未订阅，执行相应的操作
//                    print("用户未订阅")
//                }
//            } catch {
//                print("验证购买凭据失败: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    public static func completeTransactions() {
//        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
//            for purchase in purchases {
//                switch purchase.transaction.transactionState {
//                case .purchased, .restored:
//                    if purchase.needsFinishTransaction {
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    }
//                    // Unlock content
//                case .failed, .purchasing, .deferred:
//                    break // do nothing
//                @unknown default:
//                    break
//                }
//            }
//        }
//    }
//    
//    public static func retrieveProductsInfo(_ productIds: Set<String>, completion: @escaping (SKRetrieveResults) -> Void) {
//        SwiftyStoreKit.retrieveProductsInfo(productIds) { result in
//            if result.retrievedProducts.count > 0 {
//                completion(.success(result.retrievedProducts))
//            } else {
//                completion(.error)
//            }
//        }
//    }
//    
//    public static func purchaseProduct(_ productId: String, completion: @escaping (SKPurchaseResult) -> Void) {
//        var simulatesAskToBuyInSandbox = false
//#if DEBUG
//        simulatesAskToBuyInSandbox = true
//#endif
//        SwiftyStoreKit.purchaseProduct(productId, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox) { result in
//            switch result {
//            case .success(let purchase):
//                print("ipa: purchase_Success: \(purchase.productId)")
//                var urlType: AppleReceiptValidator.VerifyReceiptURLType = .production
//#if DEBUG
//                urlType = .sandbox
//#endif
//                let appleValidator = AppleReceiptValidator(service: urlType, sharedSecret: kSharedSecret)
//                SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
//                    switch result {
//                    case .success(let receipt):
//                        print("ipa: Verify receipt success: \(receipt)")
//                        completion(.success)
//                    case .error(let error):
//                        print("ipa: Verify receipt failed: \(error)")
//                        completion(.error)
//                    }
//                }
//            case .error(let error):
//                if error.code == .paymentCancelled {
//                    print("ipa: purchase_cancel")
//                    completion(.cancel)
//                } else {
//                    print("ipa: purchase_error")
//                    completion(.error)
//                }
//            case .deferred(purchase: let purchase):
//                print("")
//            }
//        }
//    }
//    
//    public func restorePurchases(_ completion: @escaping (SKPurchaseResult) -> Void) {
//        SwiftyStoreKit.restorePurchases(atomically: true) { results in
//            if results.restoreFailedPurchases.count > 0 {
//                print("ipa: Restore Failed: \(results.restoreFailedPurchases)")
//                completion(.error)
//            }
//            else if results.restoredPurchases.count > 0 {
//                print("ipa: Restore Success: \(results.restoredPurchases)")
//                completion(.success)
//            }
//            else {
//                print("ipa: Nothing to Restore")
//                completion(.error)
//            }
//        }
//    }
//}
