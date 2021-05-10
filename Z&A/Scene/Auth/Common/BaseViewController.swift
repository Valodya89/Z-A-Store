//
//  BaseViewController.swift
//  LipParty
//
//  Created by Valodya Galstyan on 6/16/20.
//  Copyright © 2020 Valodya Galstyan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    var transparentView: UIView?
    var bottomSheetY = 0.0
    
    // Social manager
    // Facebook login result callback
    private var didFacebookResult:(Bool, Any?)->() = {_,_ in }
    
    var showAuthNavigationBar: Bool = false {
        didSet {
            if showAuthNavigationBar {
                addAuthNavigationBar()
            }
        }
    }
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        // Observe access token changes
        // This will trigger after successfully login / logout
    }
         
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    func addAuthNavigationBar() {
        
    }
    
    func showAlert(title: String, message: String, callback: @escaping (() -> Void)) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            callback()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }

    
    @IBAction func authBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func socialButtonsAction(_ sender: UIButton) {
        switch sender.tag {
        case 3:
            print("Instagram clicked")
        case 4:
            break
        default:
            break
        }
    }
    
    func didLoginUserWithFacebook(success: Bool, message: String) {
        print()
    }
    

    
}
