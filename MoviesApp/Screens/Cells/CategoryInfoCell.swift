//
//  CategoryCell.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class CategoryInfoCell: UITableViewCell, TableViewBindableCell {
    typealias Item = String
    
    static let reuseIdentifier = "CategoryInfoCell"
    
    static let nibName: String = "CategoryInfoCell"
    
    @IBOutlet weak var categoryText: UILabel!
    
    func bind(item : String) {
        categoryText.text = item
    }
}
