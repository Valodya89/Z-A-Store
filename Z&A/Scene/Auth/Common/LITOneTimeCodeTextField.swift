//
//  OneTimeCodeTextField.swift
//  TextInput
//
//  Created by Vardan  on 7/22/20.
//  Copyright © 2020 Vardan . All rights reserved.
//

import UIKit
protocol LITOneTimeCodeTextFieldDelegate: class {
    func didChangeChar()
}

class LITOneTimeCodeTextField: UITextField {

    var didEnterLastDigit: ((String) -> ())?
    var defaultCaracterValue = "-"
    weak var oneTimeDelegate: LITOneTimeCodeTextFieldDelegate?
    
    var isConfigured = false
    var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
       let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 5) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()
        
        let lebelsStackView = createLabelsStackView(with: slotCount)
        addSubview(lebelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            lebelsStackView.topAnchor.constraint(equalTo: topAnchor),
            lebelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lebelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lebelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        digitLabels = []
        for _ in 1...count {
            let innerStackView = UIStackView()
            innerStackView.translatesAutoresizingMaskIntoConstraints = false
            innerStackView.axis = .vertical
            innerStackView.alignment = .fill
//            innerStackView.distribution = .fillEqually
            innerStackView.spacing = 8
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont(name: "Muli-ExtraBold", size: 17)
            label.textColor = .yellow
            label.text = defaultCaracterValue
            label.isUserInteractionEnabled = true
            
            let lineView = UIView()
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = .yellow
            lineView.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: 1)
            
            
            
            innerStackView.addArrangedSubview(label)
            innerStackView.addArrangedSubview(lineView)
            stackView.addArrangedSubview(innerStackView)
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                currentLabel.textColor = .yellow
            } else {
                currentLabel.textColor =  .yellow
                currentLabel.text = defaultCaracterValue
            }
        }
        
        //if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        //}
    }
}
extension LITOneTimeCodeTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.oneTimeDelegate?.didChangeChar()
        guard let characterCount = textField.text?.count else { return false }
        
        
        return characterCount < digitLabels.count || string == ""
        
    }
}
