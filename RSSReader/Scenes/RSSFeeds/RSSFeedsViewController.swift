//
//  RSSFeedsViewController.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import UIKit

protocol RSSFeedsView : class {
    
    func loadData()
    func endViewController()
    func presentArticlesView(with RSSFeed : RSSFeeds)
}

class RSSFeedsViewController: UIViewController {
    
    var presenter : RSSFeedsPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        configureBarButtons()
        configureTitle()
        presenter?.viewDidLoad()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "RSSFeedsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
    }
    
    func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(signOutTapped))
    }
    
    func configureTitle() {
        title = "RSS Feeds"
    }
    
    @objc func addTapped() {
        showRSSFeedRegisterDialog()
    }
    
    @objc func signOutTapped() {
        presenter?.logout()
    }
    
    func showRSSFeedRegisterDialog() {
        let dialogAlert = UIAlertController(title: "Subscribe to a RSS feed",
                                      message: "Enter the URL",
                                      preferredStyle: .alert)
        
        dialogAlert.addTextField { (textField) in
            textField.text = ""
        }
        dialogAlert.addAction(UIAlertAction(title: "Add",
                                            style: .default,
                                            handler: { [weak dialogAlert, weak self] (_) in
                                                if let textField = dialogAlert?.textFields![0], let text = textField.text {
                                                    self?.presenter?.registerNewRSSFeed(urlString: text)
                                                }
            
        }))

        self.present(dialogAlert, animated: true, completion: nil)
    }
}

extension RSSFeedsViewController : RSSFeedsView {
    
    func presentArticlesView(with RSSFeed: RSSFeeds) {
        let articlesVC = ArticlesFeedsViewController()
        let presenter = ArticlesFeedsPresenterImp(view: articlesVC, selectedRSS: RSSFeed)
        articlesVC.presenter = presenter
        navigationController?.pushViewController(articlesVC, animated: true)
    }
    
    func endViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadData() {
        tableView.reloadData()
    }

}

extension RSSFeedsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectedRSS(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension RSSFeedsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.rssfeeds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RSSFeedsTableViewCell
        presenter?.configure(cell: cell, at: indexPath)
        return cell
    }
    
    
}


