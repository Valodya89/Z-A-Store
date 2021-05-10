//
//  CardViewController.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/27/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit


final class CardViewController: UIViewController, StoryboardInitializable {
    // MARK: - IBOutlets

    @IBOutlet weak var bgView: UIView!
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var expDateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    // MARK: - Variables

    var router: CardRouter?
    var cardModel: CardSuggestedModel?
    var userName = ""
    
    private let localMemoryManager = LocalMemoryManager()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        uiConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchHandleCard), name: Constants.NotificationName.updateCard, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchHandleCard()
    }
    

    // MARK: - IBActions

    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        signOut()
    }
    
    @IBAction func addCardTapped(_ sender: UIButton) {
        goToAddCardVC()
    }

    @IBAction func tappedCard(_ sender: UIButton) {
//        router?.route(to: .previewQR(CardSuggestedModel(ownerName: "", ownerSurname: "", ownerPhone: "", ownerEmail: "", creationDate: 0, activeUntil: 0, code: 0, type: "gold", useCount: 0)))
        if let card = cardModel {
            router?.route(to: .previewQR(card))
        }
    }
    
    // MARK: - Functions

    private func signOut() {
        localMemoryManager.remove(for: .username)
        localMemoryManager.remove(for: .card)
        router?.route(to: .signIn)
    }
    
    @objc func fetchHandleCard() {
        cardModel = localMemoryManager.fetchCard(for: .card)
        
//        cardModel = CardSuggestedModel(ownerName: "Albert", ownerSurname: "Mnatsakanyan", ownerPhone: "", ownerEmail: "", creationDate: 0, activeUntil: 0, code: 0, type: "gold", useCount: 0)
        
        switch cardModel {
        case .some(let card):
            fillCard(card)
            addCardButton.isHidden = true
            cardView.isHidden = false
        case .none:
            addCardButton.isHidden = false
            cardView.isHidden = true
        }
    }
    
    private func goToAddCardVC() {
        router?.route(to: .addCard(userName))
    }

    private func fillCard(_ card: CardSuggestedModel) {
        nameLabel.text = card.ownerName + " " + card.ownerSurname
        expDateLabel.text = "Valid thru " + (TimeConvertr(unixtimeInterval: card.activeUntil).toString ?? "")

        if card.type.lowercased() == "gold" {
            bgView.backgroundColor = .black
            cardImageView.image = UIImage(named: Constants.Images.goldBgIcon)
            logoImageView.image = #imageLiteral(resourceName: "z&a_stores3_icon") // UIImage(named: Constants.Images.logoDarkIcon)
            qrImageView.image = generateQRCode(from: String(card.code))?.imageByMakingWhiteBackgroundTransparent()
//            qrImageView.image = CodableImage(string: String(card.code)).toImage?.imageByMakingWhiteBackgroundTransparent()
            expDateLabel.textColor = .black
            nameLabel.textColor = .black

        } else {
            bgView.backgroundColor = .white
            cardImageView.image = UIImage(named: Constants.Images.blackBgIcon)
            logoImageView.image = UIImage(named: Constants.Images.logoLightIcon)
            qrImageView.image = generateQRCode(from: String(card.code))?.imageByMakingWhiteBackgroundTransparent()?.withTintColor(UIColor.zaColor)
//            qrImageView.image = CodableImage(string: String(card.code)).toImage?.imageByMakingWhiteBackgroundTransparent()?.withTintColor(UIColor.zaColor)
            expDateLabel.textColor = UIColor.zaColor
            nameLabel.textColor = UIColor.zaColor
        }
    }
    
    private func uiConfig() {
        addCardButton.layer.cornerRadius = addCardButton.bounds.height / 2
    }
    
    
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}
