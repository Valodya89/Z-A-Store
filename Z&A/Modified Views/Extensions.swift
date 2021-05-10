//
//  Extensions.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/29/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

extension UILabel {
    func set(withKerning kerning: CGFloat) {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)

        attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSMakeRange(0, textString.count))

        attributedText = attributedString
    }
}

extension UIImage {
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        let image = UIImage(data: pngData()!)!
//        let rawImageRef: CGImage = image.cgImage!

        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size)
        

        var returnImage: UIImage?
        let sz = image.size
        UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sz))
        let noAlphaImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let noAlphaCGRef = noAlphaImage?.cgImage
        if let imgRefCopy = noAlphaCGRef?.copy(maskingColorComponents: colorMasking) {
            returnImage = UIImage(cgImage: imgRefCopy)
        }
        return returnImage
        
//        let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking)
//        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: image.size.height)
//        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
//        UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return result
    }
}

extension UIColor {
    static let zaColor: UIColor = UIColor(red: 0.704, green: 0.643, blue: 0.317, alpha: 1)
}


extension UILabel {
    
    public func updateGradientTextColor(gradientColors : [UIColor] = [UIColor(white: 0, alpha: 0.95) ,  UIColor(white: 0, alpha: 0.6) ]) {
        // Create size of intrinsic size for the label with current text.
        // Otherwise the gradient textColor will repeat when text is changed.
        let size = CGSize(width: intrinsicContentSize.width, height: 1)
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // Always remember to close the image context when leaving
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Create the gradient
        var  colors : [CGColor] = []
        for color in gradientColors {
            colors.append(color.cgColor)
        }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: nil
            ) else { return }
        
        // Draw the gradient in image context
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: CGPoint(x: size.width, y: 0), // Horizontal gradient
            options: []
        )
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            // Set the textColor to the new created gradient color
            self.textColor = UIColor(patternImage: image)
        }
    }
    
     public func textHeight(withWidth width: CGFloat) -> CGFloat {
          guard let text = text else {
              return 0
          }
        
        return text.height(withConstrainedWidth: width, font: font)
      }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}


extension UIViewController {
    
    func showAlertMessage(_ title: String, meassage: String = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertMessage(_ title: String, meassage: String = "", actionText: String, action: @escaping (() -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                action()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorAlertMessage(_ message: String = "Something went wrong") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func setRootController(_ viewController: UIViewController) {
//        UIWindow.key?.rootViewController = viewController
//        UIWindow.key?.makeKeyAndVisible()
//    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIScreen {

    public func setBrightness(to value: CGFloat, duration: TimeInterval = 0.3, ticksPerSecond: Double = 120) {
            let startingBrightness = UIScreen.main.brightness
            let delta = value - startingBrightness
            let totalTicks = Int(ticksPerSecond * duration)
            let changePerTick = delta / CGFloat(totalTicks)
            let delayBetweenTicks = 1 / ticksPerSecond

            let time = DispatchTime.now()

            for i in 1...totalTicks {
                DispatchQueue.main.asyncAfter(deadline: time + delayBetweenTicks * Double(i)) {
                    UIScreen.main.brightness = max(min(startingBrightness + (changePerTick * CGFloat(i)),1),0)
                }
            }

        }
}
