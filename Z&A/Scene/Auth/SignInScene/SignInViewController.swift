//
//  SignInViewController.swift
//  Z&A
//
//  Created by Valodya Galstyan on 3/18/21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController, StoryboardInitializable {

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    
    // MARK: - Properties
    
    var router: SignInRouter?
    var interactor: SignInInteractable?
    private let localMemoryManager = LocalMemoryManager()
    
    private var username = ""
    private var password = ""
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        configUI()
        confirmDelegates()
        registerKeyboardNotification()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text!
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text!
    }
    
    
    @IBAction func signInTapped(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func continueGuestTapped(_ sender: UIButton) {
        localMemoryManager.store(model: "", for: .username)
        router?.route(to: .main(""))
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        goToSignUp()
    }
    
    
    // MARK: - Functions
    
    private func configUI() {
        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
        guestButton.layer.cornerRadius = guestButton.bounds.height / 2
    }
    
    private func confirmDelegates() {
        usernameTF.delegate = self
        passwordTF.delegate = self
    }
    
    private func signIn() {
        view.endEditing(true)
        signInButton.isUserInteractionEnabled = false
        interactor?.signIn(.init(username: username, password: password))
    }
    
    private func goToSignUp() {
        router?.route(to: .signUp)
    }
}


// MARK: - UITextField Delegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTF:
            passwordTF.becomeFirstResponder()
        case passwordTF:
            passwordTF.resignFirstResponder()
            if !username.isEmpty && !password.isEmpty {
                signIn()
            }
        default:
            break
        }
        return true
    }
}


// MARK: - Keyboard

extension SignInViewController {
    
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


// MARK: - SignInDisplayable

extension SignInViewController: SignInDisplayable {
    func display(interable model: SignInModel.ViewModel) {
        router?.route(to: .main(username))
    }

    func display(error: String) {
        print("Error = \(error)")
        signInButton.isUserInteractionEnabled = true
        showAlertMessage(error)
    }
}
