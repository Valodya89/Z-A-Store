//
//  PreviewQrViewController.swift
//  Z&A
//
//  Created by ITHD LLC on 30.03.21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class PreviewQrViewController: UIViewController, StoryboardInitializable {

    @IBOutlet var qrImageView: UIImageView!
    
    var card: CardSuggestedModel!
    private var usersBrightness: CGFloat = 1
    private var willEnterForegroundWasCalled = false
    private var viewWillDisappearWasCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersBrightness = UIScreen.main.brightness
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configUI()
        DispatchQueue.main.async {
            UIScreen.main.setBrightness(to: 1, duration: 0.6)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewWillDisappearWasCalled = true
        DispatchQueue.main.async {
            UIScreen.main.setBrightness(to: self.usersBrightness, duration: 0.3)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    

    @IBAction func closeTapped(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    
    private func configUI() {
        qrImageView.image = CodableImage(string: String(card.code)).toImage?.imageByMakingWhiteBackgroundTransparent()?.withTintColor(UIColor.black)
    }
}

// MARK: - Display Brightness

extension PreviewQrViewController {
    
    @objc private func applicationWillResignActive() {
        UIScreen.main.setBrightness(to: usersBrightness, duration: 0.3)
    }
    
    @objc private func applicationWillEnterForeground() {
        willEnterForegroundWasCalled = true
        usersBrightness = UIScreen.main.brightness
        UIScreen.main.setBrightness(to: 1, duration: 0.6)
    }
    
    @objc private func applicationDidBecomeActive() {
        // When the app enters the foreground again because the user closed notification
        // or control center then `UIApplicationWillEnterForeground` is not called, necessitating
        // also listening to `UIApplicationDidBecomeActive`.
        // This guard ensures the brightness is not increased when the app is opened from the home
        // screen, the multitasker, etc., and also when the view controller is dismissing, which can
        // occur if the user closes the view control quickly after closing notification or control center
        guard !willEnterForegroundWasCalled, !viewWillDisappearWasCalled else {
            willEnterForegroundWasCalled = false
            return
        }
        
        usersBrightness = UIScreen.main.brightness
        UIScreen.main.setBrightness(to: 1, duration: 0.6)
    }
}
