//
//  ConfirmViewController.swift
//  Z&A
//
//  Created by Valodya Galstyan on 3/18/21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class CodeVerificationViewController: UIViewController, StoryboardInitializable {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var codeTextField: LITOneTimeCodeTextField!
    @IBOutlet weak var resendLabelView: UIView!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    // MARK: - Properties
    
    var router: CodeVerificationRouter?
    var interactor: CodeVerificationInteractable?
    
    var timer = Timer()
    var counter = 60
    var username = ""
    var validationCode = ""

    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        startTimer()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeTextField.text = ""
        codeTextField.textDidChange()
    }

    
    // MARK: - IBActions
    
    @IBAction func resendTapped(_ sender: UIButton) {
        resendButton.isUserInteractionEnabled = false
        resendCode()
    }
    
    @IBAction func verifyTapped(_ sender: UIButton) {
        verifyCode()
    }
    
    // MARK: - Functions
    
    func startTimer(){
        counter = 60
        let seconds = 1.0
        timer = Timer.scheduledTimer(timeInterval: seconds, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func configureUI() {
        resendLabel.updateGradientTextColor(gradientColors: [#colorLiteral(red: 1, green: 0, blue: 0.3058823529, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.5019607843, alpha: 1)])
        resendLabelView.backgroundColor = .clear
//        resendLabelView.setGradientBacgroundWithTwoColors(colorOne: #colorLiteral(red: 1, green: 0, blue: 0.3058823529, alpha: 1), colorTwo: #colorLiteral(red: 1, green: 0, blue: 0.5019607843, alpha: 1), cornerRadius: 0)
        resendLabelView.isHidden = true
        resendLabel.textColor = .black
        resendLabel.text = ("Resend again \(counter)")
        resendButton.isUserInteractionEnabled = false
        codeTextField.defaultCaracterValue = "x"
        codeTextField.oneTimeDelegate = self
        codeTextField.isConfigured = false
        codeTextField.configure(with: 5)
        codeTextField.didEnterLastDigit = { [weak self] code in
            guard let self = self else { return }
            self.validationCode = code
            if code.count == 5 {
                self.view.endEditing(true)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        self.view.addGestureRecognizer(tapGesture)
        
        verifyButton.layer.cornerRadius = verifyButton.bounds.height / 2
    }
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            counter -= 1
            resendButton.isUserInteractionEnabled = false
            resendLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0.3058823529, alpha: 1)
            resendLabelView.isHidden = true
            resendLabel.text = ("Resend again \(counter)")
            
        } else {
            resendLabel.text = "Resend"
            resendLabel.updateGradientTextColor(gradientColors: [#colorLiteral(red: 1, green: 0, blue: 0.3058823529, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.5019607843, alpha: 1)])
            resendLabelView.isHidden = false
            if counter == 0 {
                resendButton.isUserInteractionEnabled = true
                stopTimer()
            }
        }
    }
    
    @objc func hideKeyBoard() {
        view.endEditing(true)
    }
    
    func checkValidationCode() {
        if validationCode.count == 5 {
            self.verifyCode()
        }
    }
    
    func verifyCode() {
        interactor?.verify(.init(verificationCode: validationCode, username: username))
    }
    
    func resendCode() {
        interactor?.resend(.init(verificationCode: validationCode, username: username))
    }
}


// MARK: - LITOneTimeCodeTextField Delegate

extension CodeVerificationViewController: LITOneTimeCodeTextFieldDelegate {
    func didChangeChar() {
//        self.errorLabel.text = ""
        checkValidationCode()
    }
}


// MARK: - SignInDisplayable

extension CodeVerificationViewController: CodeVerificationDisplayable {
    func display(interable model: CodeVerificationModel.ViewModel) {
        if model.isResend {
            self.resendButton.isUserInteractionEnabled = false
            self.startTimer()
        }
        if model.isVerify {
            showAlertMessage("Your email is verified.", actionText: "Ok") {
                self.router?.route(to: .signIn)
            }
        }
    }

    func display(error: String) {
        print("Error = \(error)")
        showAlertMessage(error)
    }
}
