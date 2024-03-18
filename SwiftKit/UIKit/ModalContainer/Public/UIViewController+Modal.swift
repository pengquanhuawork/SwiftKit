//
//  UIViewController+Modal.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/10.
//

import Foundation
import UIKit

public struct ModalConfiguration {
    public var height: CGFloat = 100
    public var indicatorEnable: Bool = true
    public var heightChangeable: Bool = false
    public var indicatorHeight: CGFloat = 28.0
    public var indicatorColor: UIColor = .white
    public var backgroundCoverEnable: Bool = true
    public var backgroundCoverColor: UIColor = .clear
    public var backgroundTouchEnable: Bool = true
    public init() {
        
    }
}

public typealias SCModelContainerDismissCompletion = (() -> Void)?

public extension UIViewController {
    

    func sk_present(_ rootVC: UIViewController, animated flag: Bool = true, configuration: ModalConfiguration?, completion: (() -> Void)?) {

        let presentingVC = self.sc_nestModalContainer() ?? self

        let config = configuration ?? ModalConfiguration()

        let presentedVC = SCModalContainerViewController(rootViewController: rootVC,
                                                         modalHeight: config.height,
                                                         indicatorEnable: config.indicatorEnable,
                                                         indicatorHeight: config.indicatorHeight,
                                                         indicatorColor: config.indicatorColor)
        presentedVC.sc_maxHeight = config.height
        presentedVC.sc_presentingViewController = presentingVC
        presentedVC.pi_heightChangeable = config.heightChangeable
        presentingVC.sc_presentedViewController = presentedVC

        if config.backgroundCoverEnable {
            let backgroundView = SCBackgroundView()
            backgroundView.presentedViewController = presentedVC
            presentedVC.pi_backgroundView = backgroundView
            presentingVC.view.addSubview(backgroundView)
            backgroundView.snp.makeConstraints { make in
                make.edges.equalTo(presentingVC.view)
            }
        }

        presentedVC.willMove(toParent: presentingVC)
        presentingVC.addChild(presentedVC)
        presentingVC.view.addSubview(presentedVC.view)
        presentedVC.didMove(toParent: presentingVC)

        presentedVC.view.snp.makeConstraints { make in
            make.left.bottom.equalTo(presentingVC.view)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(config.height)
        }

        presentingVC.view.setNeedsLayout()
        presentingVC.view.layoutIfNeeded()

        presentedVC.presentAnimation(flag, completion: completion)
    }

    func sc_present(_ rootVC: UIViewController, animated flag: Bool, configuration: ModalConfiguration?, completion: (() -> Void)?, dismissCompletion: SCModelContainerDismissCompletion) {
        self.sc_dismissCompletion = dismissCompletion
        sk_present(rootVC, animated: flag, configuration: configuration, completion: completion)
    }

    func sc_dismiss(with animated: Bool, completion: (() -> Void)?) {
        var presentingVC: UIViewController?
        var presentedVC: UIViewController?
        var vc: UIViewController? = self

        while let viewController: UIViewController = vc {
            if let presentingViewController = viewController.sc_presentingViewController {
                presentingVC = presentingViewController
                presentedVC = viewController
                break
            } else if let presentedViewController = viewController.sc_presentedViewController {
                presentingVC = viewController
                presentedVC = presentedViewController
                break
            }

            vc = viewController.view.superview?.btd_viewController()
        }

        guard let validPresentingVC = presentingVC, let validPresentedVC = presentedVC as? SCModalContainerViewController else {
            return
        }

        validPresentedVC.dismissAnimation(animated, completion: completion)
    }

    func pi_didTapModalContainerViewController() {
        // Implement your logic
    }

    func pi_ignoreViewWhenTapModalContainerViewController() -> [UIView]? {
        return nil
    }

    func pi_ignoreViewWhenPanModalContainerViewController() -> [UIView]? {
        return nil
    }

    private func sc_nestModalContainer() -> UIViewController? {
        var vc: UIViewController? = self
        while let viewController: UIViewController = vc, !(viewController is SCModalContainerViewController) {
            let superView = viewController.view.superview
            vc = superView?.btd_viewController()
        }
        return vc
    }

    // MARK: - Accessors

    private struct AssociatedKeys {
        static var backgroundViewKey = "pi_backgroundView"
        static var positionKey = "pi_position"
        static var heightChangeableKey = "pi_heightChangeable"
        static var maxHeightKey = "sc_maxHeight"
        static var defaultHeightKey = "sc_defaultHeight"
        static var dismissCompletionKey = "sc_dismissCompletion"
        static var presentedViewControllerKey = "sc_presentedViewController"
        static var presentingViewControllerKey = "sc_presentingViewController"
    }

    var pi_backgroundView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backgroundViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var pi_position: PIModalPosition {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.positionKey) as! PIModalPosition
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.positionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var pi_heightChangeable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.heightChangeableKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.heightChangeableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var sc_maxHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.maxHeightKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maxHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var sc_defaultHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.defaultHeightKey) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defaultHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var sc_dismissCompletion: SCModelContainerDismissCompletion {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dismissCompletionKey) as? SCModelContainerDismissCompletion ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dismissCompletionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var sc_presentedViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.presentedViewControllerKey) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.presentedViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var sc_presentingViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.presentingViewControllerKey) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.presentingViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
