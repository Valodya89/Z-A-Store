//
//  BrandDetailViewController.swift
//  Z&A
//
//  Created by Valodya Galstyan on 3/9/21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import Kingfisher

final class BrandDetailViewController: UIViewController, StoryboardInitializable {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewForSlide: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    // MARK: - Properties
    
    var brandDetailUrl: String = ""
    var brandName: String = ""
    private var imagesURL: [String] = []
    private var brandDescription: String = ""
    
    let localMemoryManager = LocalMemoryManager()
    var storedBrendDetailsList: BrendDetailsList?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func loadWebView() {
        activityView.startAnimating()
        activityView.isHidden = false
        scrollView.isHidden = true
        configureDelegates()
        webView.load(URLRequest(url: URL(string: brandDetailUrl)!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        titleLbl.text = self.brandName
        
        storedBrendDetailsList = localMemoryManager.fetchBrendDetailsList(for: .brendDetailsList)
        
        switch storedBrendDetailsList {
        case .some(let storedBrendList):
            if storedBrendList.brendDetailsList.count > 0 {
                activityView.stopAnimating()
                activityView.isHidden = true
                for brend in storedBrendList.brendDetailsList where brend.brandName == self.brandName {
                    self.descriptionLbl.text = brend.brandDescription
                    self.imagesURL = brend.imagesURL
                    configureSlideView()
                    return
                }
                
                loadWebView()
            } else {
                loadWebView()
            }
        case .none:
            loadWebView()
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Functions
    
    private func configureDelegates() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func configureSlideView() {
        
        if self.imagesURL.count > 0 {
            
            let slideScrollView = UIScrollView(frame: self.viewForSlide.bounds)
            slideScrollView.backgroundColor = .clear
            slideScrollView.isPagingEnabled = true
            
            self.viewForSlide.addSubview(slideScrollView)
            
            var imageViewWidth: CGFloat = self.viewForSlide.bounds.width
            
            for (index,image) in self.imagesURL.enumerated() {
                let imageView = UIImageView(frame: CGRect(x: CGFloat(index)*imageViewWidth, y: 0, width: self.viewForSlide.bounds.width, height: self.viewForSlide.bounds.height))
                imageView.backgroundColor = .clear
                let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 5)
                imageView.kf.indicatorType = .activity
                imageView.kf.setImage(
                    with: URL(string: image),
                    placeholder: UIImage(named: "ic_default_cover"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
                imageView.contentMode = .scaleAspectFit
                imageView.layer.masksToBounds = true
                imageView.clipsToBounds = true
                slideScrollView.addSubview(imageView)
            }
            
            slideScrollView.contentSize = CGSize(width: imageViewWidth*CGFloat(imagesURL.count), height: imageViewWidth)
        }
    }
}


// MARK: - WKUI and WKNavigation Delegate

extension BrandDetailViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("navigation = >> \(navigation)")
        
        if let myURL = NSURL(string: self.brandDetailUrl) {
            
            do {
                let myHTMLString = try String(contentsOf: myURL as URL, encoding: String.Encoding.utf8)
                print("HTML : \(myHTMLString)")
                
                do {
                    let doc: Document = try SwiftSoup.parse(myHTMLString)
                    var description = ""
                    if let body = try? doc.body() {
                        print("body ==> \(body)")
                        
                        if let brandDescriptionList = try? body.getElementsByClass("content_wrap").first()?.getAllElements().first()?.getChildNodes()[1].getChildNodes()[1].getChildNodes()[1].getChildNodes()[1].getChildNodes()[1].getChildNodes().first?.getChildNodes().first?.getChildNodes()[1].getChildNodes()[1].getChildNodes() {
                            //[3].unwrap()
                            print("brandDescriptionList count ==== >> \(brandDescriptionList.count)")
                            if brandDescriptionList.count > 0 {
                                if let newDoc =  try? SwiftSoup.parse(brandDescriptionList.first!.parent()?.outerHtml() ?? "") {
                                    let link = try? newDoc.select("p")
                                    if let htmlStr = try? link?.html() {
                                        let text = htmlStr.replacingOccurrences(of: "<br>", with: "\n")
                                        if text.contains(">") {
                                            
                                            if let newHtmlStr = text.split(separator: ">").last {
                                                if newHtmlStr.contains("</span") {
                                                    var str = newHtmlStr.replacingOccurrences(of: "</span", with: "")
                                                    description += str + "\n"
                                                } else {
                                                    description += newHtmlStr + "\n"
                                                }
                                                
                                                print("html text ----->> \(newHtmlStr)")
                                            }
                                        } else {
                                            description += htmlStr.replacingOccurrences(of: "<br>", with: "\n") + "\n"
                                            print("html text ----->> \(htmlStr.replacingOccurrences(of: "<br>", with: "\n"))")
                                        }
                                    }
                                }
                            }
                            
                            self.brandDescription = description.replacingOccurrences(of: "&nbsp;", with: " ")
                            print("description == >>> \(self.brandDescription)")
                        }
                        
                        if let imagesNodeList = try? body.getElementsByClass("content_wrap").first()?.getAllElements().first()?.getChildNodes()[1].getChildNodes()[1].getChildNodes()[1].getChildNodes()[1].getChildNodes().first?.getChildNodes().first?.getChildNodes().first?.getChildNodes().first?.getChildNodes().first?.getChildNodes()[1].getChildNodes()[1].getChildNodes().first?.getChildNodes()[1].getChildNodes() {
                            
                            if imagesNodeList.count > 0 {
                                self.imagesURL = []
                                for node in imagesNodeList {
                                    if let imgUrl = try? node.absUrl("data-image") {
                                        self.imagesURL.append(imgUrl)
                                    }
                                }
                            }
                        }
                    }
                    storedBrendDetailsList = localMemoryManager.fetchBrendDetailsList(for: .brendDetailsList)
                    if storedBrendDetailsList == nil {
                        var brendListObj = BrendDetail()
                        brendListObj.brandName = self.brandName
                        brendListObj.brandDescription = self.brandDescription
                        brendListObj.imagesURL = self.imagesURL
                        var brendDetailList = BrendDetailsList()
                        brendDetailList.brendDetailsList.append(brendListObj)
                        self.localMemoryManager.storeObj(model: brendDetailList, for: .brendDetailsList)
                    } else {
                        
                        
                        switch storedBrendDetailsList {
                        case .some(let storedBrendList):
                            self.storedBrendDetailsList = storedBrendList
                            
                            if storedBrendList.brendDetailsList.count > 0 {
                                activityView.stopAnimating()
                                activityView.isHidden = true
                                
                                if !storedBrendList.brendDetailsList.contains(where: { (brend) -> Bool in
                                    return brend.brandName == self.brandName
                                }) {
                                    var brendListObj = BrendDetail()
                                    brendListObj.brandName = self.brandName
                                    brendListObj.brandDescription = self.brandDescription
                                    brendListObj.imagesURL = self.imagesURL
                                    
                                    self.storedBrendDetailsList!.brendDetailsList.append(brendListObj)
                                    self.localMemoryManager.storeObj(model: self.storedBrendDetailsList!, for: .brendDetailsList)
                                }
                                
                            } else {
                                
                                var brendListObj = BrendDetail()
                                brendListObj.brandName = self.brandName
                                brendListObj.brandDescription = self.brandDescription
                                brendListObj.imagesURL = self.imagesURL
                                self.storedBrendDetailsList!.brendDetailsList.append(brendListObj)
                                self.localMemoryManager.storeObj(model: self.storedBrendDetailsList!, for: .brendDetailsList)
                            }
                        case .none:
                            print("")
                        }
                    }
                    configureSlideView()
                    self.descriptionLbl.text = self.brandDescription
                    let descriptionHeight = self.descriptionLbl.textHeight(withWidth: self.descriptionLbl.bounds.width)
                    let titleHeight = self.titleLbl.textHeight(withWidth: self.titleLbl.bounds.width)
                    print("images links ==========>>> ", self.imagesURL)
                    print("Finish")
                    
                    self.activityView.stopAnimating()
                    self.activityView.isHidden = true
                    self.scrollView.isHidden = false
                    
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                
            } catch {
                print("Error : \(error)")
            }
        } else {
            print("Error: \(brandDetailUrl) doesn't  URL")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            if host == "zastores.am" {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
}


struct BrendDetailsList: Codable {
    var brendDetailsList: [BrendDetail] = []
}

struct BrendDetail: Codable {
    var brandName: String = ""
    var imagesURL: [String] = []
    var brandDescription: String = ""
}
