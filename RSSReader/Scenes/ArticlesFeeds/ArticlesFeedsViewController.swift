//
//  ArticlesFeedsViewController.swift
//  RSSReader
//
//  Created by Fernando Menendez on 10/10/2020.
//

import UIKit

protocol ArticlesFeedsView : class {
    
    func showData()
}

class ArticlesFeedsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter : ArticlesFeedsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        presenter?.viewDidLoad()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "ArticlesTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
    }

}

extension ArticlesFeedsViewController : ArticlesFeedsView {
    
    func showData() {
        tableView.reloadData()
    }
}

extension ArticlesFeedsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

extension ArticlesFeedsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ArticlesTableViewCell
        presenter?.configure(cell: cell, at: indexPath)
        return cell
    }
    

}
