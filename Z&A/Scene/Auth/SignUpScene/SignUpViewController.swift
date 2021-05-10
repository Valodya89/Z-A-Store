//
//  SignUpViewController.swift
//  Z&A
//
//  Created by Valodya Galstyan on 3/18/21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController, StoryboardInitializable {
    
    
    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // MARK: - Properties
    
    var router: SignUpRouter?
    var interactor: SignUpInteractable?
    
    private var firstName = ""
    private var lastName = ""
    private var email = ""
    private var password = ""
    private var repeatPassword = ""
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        configUI()
        confirmDelegates()
        registerKeyboardNotification()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func textChanged(_ sender: UITextField) {
        switch sender {
        case firstNameTF:
            firstName = sender.text!
        case lastNameTF:
            lastName = sender.text!
        case emailTF:
            email = sender.text!
        case passwordTF:
            password = sender.text!
        case repeatPasswordTF:
            repeatPassword = sender.text!
        default:
            break
        }
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        signUp()
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        goToSignIn()
    }

    
    // MARK: - Functions
    
    private func configUI() {
        signUpButton.layer.cornerRadius = signUpButton.bounds.height / 2
    }
    
    private func confirmDelegates() {
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        repeatPasswordTF.delegate = self
    }
    
    private func signUp() {
        view.endEditing(true)
        signUpButton.isUserInteractionEnabled = false
        interactor?.signUp(.init(name: firstName, surname: lastName, username: email, password: password, confirmPassword: repeatPassword))
    }
    
    private func goToSignIn() {
        router?.route(to: .signIn)
    }
}


// MARK: - UITextField Delegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF:
            lastNameTF.becomeFirstResponder()
        case lastNameTF:
            emailTF.becomeFirstResponder()
        case emailTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            repeatPasswordTF.becomeFirstResponder()
        case repeatPasswordTF:
            repeatPasswordTF.resignFirstResponder()
            if repeatPassword != "" {
                signUp()
            }
        default:
            break
        }
        return true
    }
}


// MARK: - Keyboard

extension SignUpViewController {
    
    /// Register notification for keyboard show and hide
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    /// Configure screen ui when keyboard will show and hide
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                // close keyboard
                scrollView.contentInset = .zero
            } else {
                // open keyboard
                scrollView.contentInset.bottom = height
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}


// MARK: - SignUpDisplayable

extension SignUpViewController: SignUpDisplayable {
    func display(interable model: SignUpModel.ViewModel) {
        router?.route(to: .codeVerification(username: model.username))
    }

    func display(error: String) {
        print("Error = \(error)")
        signUpButton.isUserInteractionEnabled = true
        showAlertMessage(error)
    }
}
