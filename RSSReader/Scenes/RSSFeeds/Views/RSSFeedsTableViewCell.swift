//
//  RSSFeedsTableViewCell.swift
//  RSSReader
//
//  Created by Fernando Menendez on 09/10/2020.
//

import UIKit

class RSSFeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
        
    func configure(title : String) {
        titleLabel.text = title
    }
    
    func configure(url : String) {
        urlLabel.text = url
    }
}
