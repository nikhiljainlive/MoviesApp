//
//  TableViewBindable.swift
//  MoviesApp
//
//  Created by Admin on 01/05/21.
//

import UIKit

protocol TableViewBindableCell : UITableViewCell {
    associatedtype Item
    
    static var reuseIdentifier : String { get }
    static var nibName : String { get }
    
    func bind(item : Item)
}
