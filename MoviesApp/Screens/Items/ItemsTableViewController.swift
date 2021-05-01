//
//  MoviesTableViewController.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class ItemsTableViewController<T : TableViewBindableCell>: UITableViewController {
    var onItemSelected : ((_ item : T.Item) -> Void)?
    
    var defaultItems : [T.Item]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var items : [T.Item]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isEmpty : Bool {
        return items?.isEmpty ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(UINib.init(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items?.count ?? 0)
        return isEmpty ? (defaultItems?.count ?? 0) : (items?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionItem = isEmpty ? defaultItems?[indexPath.row] : items?[indexPath.row]
        
        guard let item = optionItem else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
        cell.bind(item: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = isEmpty ? defaultItems?[indexPath.row] : items?[indexPath.row]  else {
            return
        }
        
        onItemSelected?(item)
    }
}
