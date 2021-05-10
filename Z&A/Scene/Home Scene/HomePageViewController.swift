//
//  HomePageViewController.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/27/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

enum ShowHideState {
    case show
    case hide
}

final class HomePageViewController: UIViewController, StoryboardInitializable {
    @IBOutlet var enterPinView: UIView!
    @IBOutlet var enterPinLabel: GradientLabel!
    @IBOutlet var showHideButton: UIButton!
    @IBOutlet var digitsButtons: [UIButton]!

    var router: HomeRouter?
    var interactor: HomeInteractable?
    var showHideState = ShowHideState.hide
    var pin = ""
    var username = ""

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        uiConfig()
    }

    // MARK: - IBActions

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    @IBAction func showHidePressed(_: UIButton) {
        if showHideState == .hide {
            showHideState = .show
            showHideButton.setImage(UIImage(named: "eye_icon"), for: .normal)
            showPinDigits()
        } else {
            showHideState = .hide
            showHideButton.setImage(UIImage(named: "eye_slash_icon"), for: .normal)
            hidePinDigits()
        }
    }

    @IBAction func digitsPressed(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            // Delete button
            pin = String(pin.dropLast())

        case 11:
            // done button

            // Check internet connection
            guard Reachability.isConnectedToNetwork() else {
                let alert = UIAlertController(title: "No internet connection", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
                return
            }

            interactor?.addCard(HomeModel.Request(username: username, pin: pin))

        default:
            // 0 1 2 3 4 5 6 7 8 9 buttons
            if pin.count < 8 {
                pin = pin + String(sender.tag)
            }
        }

        if pin.isEmpty {
            enterPinLabel.text = "Enter your PIN code (8 digits)"
            enterPinLabel.set(withKerning: 0)
            showHideButton.isHidden = true

        } else {
            enterPinLabel.text = pin
            if showHideState == .hide {
                hidePinDigits()
            }

            showHideButton.isHidden = false
        }
    }

    // MARK: - Functions

    private func uiConfig() {
        enterPinLabel.gradientColors = [UIColor.yellow.cgColor, UIColor.gray.cgColor, UIColor.yellow.cgColor]
        showHideButton.setImage(UIImage(named: "eye_slash_icon"), for: .normal)
        enterPinView.layer.cornerRadius = enterPinView.frame.height / 8
        enterPinView.layer.borderWidth = 1
        enterPinView.layer.borderColor = UIColor.zaColor.cgColor

        if let firaSansRegular = UIFont(name: "FiraSans-Regular", size: 14) {
            enterPinLabel.font = firaSansRegular
        }

        for digit in digitsButtons {
            digit.layer.borderWidth = 1
            digit.layer.borderColor = UIColor.zaColor.cgColor
        }
    }

    private func showPinAlert() {
        let alert = UIAlertController(title: "Wrong code", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func hidePinDigits() {
        let cyrcleAttachment = NSTextAttachment()
        cyrcleAttachment.image = UIImage(named: "password_icon")
        let cyrcleString = NSAttributedString(attachment: cyrcleAttachment)
        let attributedExpression = NSMutableAttributedString()
        for character in pin {
            let substitutions: [Character: NSAttributedString] = [character: cyrcleString]

            if let substitution = substitutions[character] {
                attributedExpression.append(substitution)
            } else {
                attributedExpression.append(NSAttributedString(string: String(character)))
            }
        }

        attributedExpression.addAttributes([NSAttributedString.Key.kern: 13.0], range: NSRange(0 ..< pin.count))
        enterPinLabel.attributedText = attributedExpression
        enterPinLabel.sizeToFit()
    }

    private func showPinDigits() {
        enterPinLabel.text = pin
        enterPinLabel.set(withKerning: 13.0)
    }
}

// MARK: - HomeDisplayable

extension HomePageViewController: HomeDisplayable {
    func display(interable model: HomeModel.ViewModel) {
//        router?.route(to: .card)
        NotificationCenter.default.post(name: Constants.NotificationName.updateCard, object: nil)
        dismiss()
    }

    func display(error: String) {
        print("Error = \(error)")
        showPinAlert()
    }
}
