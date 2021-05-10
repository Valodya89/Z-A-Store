//
//  AppRoute.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/28/20.
//  Copyright (c) 2020 Albert Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

//================================================================================================
// Common App Router Service
//================================================================================================

enum PresentType {
    case root(hideBar: Bool)
    case push(hideBar: Bool)
    case present(fullScreen: Bool)
    case presentWithNavigation(fullScreen: Bool, hideBar: Bool, isModal: Bool = false)
    case modal
    case modalWithNavigation
}

protocol IRouter {
    var module: UIViewController? { get }
}

extension UIViewController {
    static func initialModule<T: IRouter>(module: T) -> UIViewController {
        guard let _module = module.module else { fatalError() }
        return _module
    }

    func navigate(type: PresentType = .push(hideBar: false), module: IRouter, completion: ((_ module: UIViewController) -> Void)? = nil) {
        guard let _module = module.module else { fatalError() }
        switch type {
        case let .root(hideBar):
//            if _module is UITabBarController {
//                UIApplication.shared.delegate?.window??.setRootViewController(_module, options: .init(direction: .fade, style: .easeInOut))
//            } else {
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.setRootViewController(
                    UINavigationController(rootViewController: _module),
                    options: .init(
                        direction: .fade,
                        style: .easeInOut
                    )
                )
                UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.makeKeyAndVisible()
                _module.navigationController?.isNavigationBarHidden = hideBar
                completion?(_module)
//            }
        case .push:
            if let navigation = navigationController {
                navigation.pushViewController(_module, animated: true)
                completion?(_module)
            }
        case let .present(state):
            if state {
                _module.modalPresentationStyle = .fullScreen
            }
            present(_module, animated: true, completion: {
                completion?(_module)
            })
        case let .presentWithNavigation(state, hideBar, modal):
            let nav = UINavigationController(rootViewController: _module)
            if state {
                nav.modalPresentationStyle = .fullScreen
            }
            _module.isModalInPresentation = modal
            _module.navigationController?.isNavigationBarHidden = hideBar
            present(nav, animated: true, completion: {
                completion?(_module)
            })
        case .modal:
            _module.modalTransitionStyle = .crossDissolve
            _module.modalPresentationStyle = .overFullScreen

            present(_module, animated: true, completion: {
                completion?(_module)
            })
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            present(nav, animated: true, completion: {
                completion?(_module)
            })
        }
    }

    func dismiss(to: IRouter? = nil, _ completion: (() -> Void)? = nil) {
        if navigationController != nil {
            navigationController?.dismiss(animated: true, completion: {
                completion?()
                return
            })

            if let module = to?.module, let viewControllers = navigationController?.viewControllers {
                if let _vc = viewControllers.filter({ type(of: $0) == type(of: module) }).first {
                    navigationController?.popToViewController(_vc, animated: true)
                }
            } else {
                navigationController?.popViewController(animated: true)
            }
            completion?()
        } else {
            dismiss(animated: true, completion: {
                completion?()
            })
        }
    }

    func backToRoot(_ completion: (() -> Void)? = nil) {
        navigationController?.popToRootViewController(animated: true)
        completion?()
    }
}

extension UIViewController {
    private struct UniqueIdProperies {
        static var pickerDelegate: IDataPickerDelegate?
        static var previousViewController: UIViewController?
    }

    // MARK: - Picker Delegate Properties

    weak var dataPickerDelegate: IDataPickerDelegate? {
        get {
            return objc_getAssociatedObject(self, &UniqueIdProperies.pickerDelegate) as? IDataPickerDelegate
        } set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &UniqueIdProperies.pickerDelegate, unwrappedValue as IDataPickerDelegate?, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }

    var previousViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &UniqueIdProperies.previousViewController) as? UIViewController
        } set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, &UniqueIdProperies.previousViewController, unwrappedValue as UIViewController?, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }

    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}

//================================================================================================
// Common Extension
//================================================================================================
@available(iOS, deprecated: 13.0)
extension UIApplication {
    /// in iOS 13 key window was deprecated, cus iPad with ios 13.0 support multyscreen and multyshare.
    /// - Parameter base: KeyWindow was deprecated for iOS 13
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController {
            let top = topViewController(presented)
            return top
        }
        return base
    }
}

public extension UIWindow {
    /// Transition Options
    struct TransitionOptions {
        /// Curve of animation
        ///
        /// - linear: linear
        /// - easeIn: ease in
        /// - easeOut: ease out
        /// - easeInOut: ease in - ease out
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut

            /// Return the media timing function associated with curve
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear: key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn: key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut: key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut: key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
            }
        }

        /// Direction of the animation
        ///
        /// - fade: fade to new controller
        /// - toTop: slide from bottom to top
        /// - toBottom: slide from top to bottom
        /// - toLeft: pop to left
        /// - toRight: push to right
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight

            /// Return the associated transition
            ///
            /// - Returns: transition
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }

        /// Background of the transition
        ///
        /// - solidColor: solid color
        /// - customView: custom view
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }

        /// Duration of the animation (default is 0.20s)
        public var duration: TimeInterval = 0.20

        /// Direction of the transition (default is `toRight`)
        public var direction: TransitionOptions.Direction = .toRight

        /// Style of the transition (default is `linear`)
        public var style: TransitionOptions.Curve = .linear

        /// Background of the transition (default is `nil`)
        public var background: TransitionOptions.Background?

        /// Initialize a new options object with given direction and curve
        ///
        /// - Parameters:
        ///   - direction: direction
        ///   - style: style
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }

        public init() {}

        /// Return the animation to perform for given options object
        internal var animation: CATransition {
            let transition = direction.transition()
            transition.duration = duration
            transition.timingFunction = style.function
            return transition
        }
    }

    /// Change the root view controller of the window
    ///
    /// - Parameters:
    ///   - controller: controller to set
    ///   - options: options of the transition
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
        var transitionWnd: UIWindow?
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case let .customView(view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case let .solidColor(color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }

        // Make animation
        layer.add(options.animation, forKey: kCATransition)
        rootViewController = controller
        makeKeyAndVisible()

        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 + options.duration) {
                wnd.removeFromSuperview()
            }
        }
    }
}

//================================================================================================
// Common Protocol Delegate
//================================================================================================

protocol IDataPickerDelegate: class {
    func didDataPicker<T>(_ data: T?)
}
