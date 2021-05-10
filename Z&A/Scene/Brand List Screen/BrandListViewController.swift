//
//  BrandListViewController.swift
//  Z&A
//
//  Created by Valodya Galstyan on 3/9/21.
//  Copyright © 2021 Albert Mnatsakanyan. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup

final class BrandListViewController: UIViewController, StoryboardInitializable {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var brendsTableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    
    
    // MARK: - Properties
    
    var router: BrandListRouter?
    var brendList: [Brend] = []
    let localMemoryManager = LocalMemoryManager()
    var storedBrendList: BrendList?
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storedBrendList = localMemoryManager.fetchBrendList(for: .brendList)
        
        switch storedBrendList {
        case .some(let storedBrendList):
            if storedBrendList.brendList.count > 0 {
                activityView.stopAnimating()
                activityView.isHidden = true
                self.brendsTableView.isHidden = false
                self.brendList = storedBrendList.brendList
                brendsTableView.delegate = self
                brendsTableView.dataSource = self
                brendsTableView.reloadData()
            } else {
                loadWebView()
                //            }
                
            }
        case .none:
            loadWebView()
        }
  
        
    }
    
    func loadWebView() {
        activityView.startAnimating()
        activityView.isHidden = false
        configureDelegates()
        brendsTableView.isHidden = true
        webView.load(URLRequest(url: URL(string: "https://zastores.am/en/")!))
        webView.isHidden = true
    }
    
    // MARK: - Functions
    
    private func configureDelegates() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        brendsTableView.delegate = self
        brendsTableView.dataSource = self
    }
    
    private func goToBrandDetailVC(brand: Brend) {
        router?.route(to: .brandDetail(brandName: brand.title, brandDetailUrl: brand.link))
    }
}


// MARK: - UITableView Delegate and DataSource

extension BrandListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "BrendCell", for: indexPath) as! BrendCell
        cell.titleLbl.text = self.brendList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected link = \(self.brendList[indexPath.row].link)")
        goToBrandDetailVC(brand: brendList[indexPath.row])
    }
}


// MARK: - WKUI and WKNavigation Delegate

extension BrandListViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("navigation = >> \(String(describing: navigation))")
        
        webView.evaluateJavaScript("document.getElementById('menu-main-menu').innerHTML.toString()") { (result, error) in
            if let html = result as? String {
                print(html)
                
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    print(try! doc.text())
                    
                    if let list = try? doc.body()?.getElementsByClass("sub-menu animated fast fadeOutDownSmall").array() {
                        for item in list {
                            if let item = item as? Element {
                                if item.getChildNodes().count > 3 {
                                    for node in item.getChildNodes() {
                                        if let newNod = node.getChildNodes().first {
                                            guard let url = try? newNod.absUrl("href") else { return }
                                            guard let title = try? newNod.getChildNodes().first?.unwrap() else { return }
                                            self.brendList.append(Brend(link: url, title: title.description))
                                            print(title)
                                            print(url)
                                        }
                                    }
                                }
                            }
                            //aa?.getChildNodes().first?.getChildNodes()
                        }
                    }
                    
                    if self.brendList.count > 0 {
                        
                        var brendListObj = BrendList()
                        brendListObj.brendList = []
                        for item in self.brendList {
                            brendListObj.brendList.append(item)
                        }
                        self.localMemoryManager.storeObj(model: brendListObj, for: .brendList)
                        
                        self.activityView.stopAnimating()
                        self.activityView.isHidden = true
                        self.brendsTableView.isHidden = false
                        self.brendList.removeFirst()
                        self.brendList.removeLast()
                        self.brendsTableView.reloadData()
                    }
                    
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }
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

struct Brend: Codable {
    var link: String = ""
    var title: String = ""
}

struct BrendList: Codable {
    var brendList: [Brend] = []
}
