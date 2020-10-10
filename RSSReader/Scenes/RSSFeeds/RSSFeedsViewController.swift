//
//  RSSFeedsViewController.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import UIKit

protocol RSSFeedsView {
    
    func loadData()
}

class RSSFeedsViewController: UIViewController {
    
    var presenter : RSSFeedsPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        presenter?.viewDidLoad()
    }
    
    func registerCells() {
        tableView.register(UINib(nibName: "RSSFeedsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
    }
}

extension RSSFeedsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
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

extension RSSFeedsViewController : RSSFeedsView {
    
    func loadData() {
        tableView.reloadData()
    }

}
