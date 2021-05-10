//
//  AboutUsViewController.swift
//  Z&A
//
//  Created by Albert Mnatsakanyan on 1/27/20.
//  Copyright © 2020 Albert Mnatsakanyan. All rights reserved.
//

import UIKit

final class AboutUsViewController: UIViewController, StoryboardInitializable {
    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var instaButton: UIButton!
    @IBOutlet var zaButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    // MARK: - IBActions

    @IBAction func backPressed(_: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func fbPressed(_: UIButton) {
        guard let url = URL(string: Constants.Requests.facebookURL) else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func instaPressed(_: UIButton) {
        guard let url = URL(string: Constants.Requests.instagramURL) else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func zaPressed(_: UIButton) {
        guard let url = URL(string: Constants.Requests.zaURL) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Functions

    private func configUI() {

        titleLabel.text = "Z&A stores app - Welcome to the luxury world of Z&A stores."
        textLabel.text = """
        It is a luxury discount platform where we unite the world’s most prestigious brands.
        Became a member and enjoy exclusive discounts at luxury boutiques of Z&A stores in Yerevan, Armenia.
        Became an honorable member of Z&A stores luxury world.
        Depending on your card the reduction can vary between 15% and 20%.
        Procedure of the card activation:
        To activate the card, you need to enter the security pin in the special opened window
        To get the security pin codes please visit any Z&A stores boutiques.
          *Discount can not be combined with other promotions and sales. It is
        only valid in Z&A stores boutiques in Yerevan, Armenia. Each card has a
        validation period, which can be found on the discount card.
        """
    }
}




