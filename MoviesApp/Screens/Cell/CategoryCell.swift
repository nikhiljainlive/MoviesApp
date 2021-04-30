//
//  CategoryCell.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class CategoryCell: UITableViewCell {

    static let reuseIdentifier = "CategoryCell"
    @IBOutlet weak var categoryText: UILabel!
    
    func bind(text : String) {
        categoryText.text = text
    }
}
