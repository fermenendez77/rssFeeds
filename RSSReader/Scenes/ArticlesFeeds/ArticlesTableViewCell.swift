//
//  ArticlesTableViewCell.swift
//  RSSReader
//
//  Created by Fernando Menendez on 10/10/2020.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(title : String) {
        titleLabel.text = title
    }
    
    func configure(url : String) {
        urlLabel.text = url
    }
    
    func configure(date : String) {
        dateLabel.text = date
    }
}


