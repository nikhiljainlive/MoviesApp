//
//  MoviesTableViewController.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    var onSearchTokenSelected : ((_ searchToken : UISearchToken) -> Void)?
    
    var movies : [Movie]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchTokens : [UISearchToken] {
        let categories = MovieSearchCategory.allCases.map { $0.rawValue }
        return categories.map {
            let searchToken = UISearchToken(icon: nil, text: $0)
            searchToken.representedObject = $0
            return searchToken
        }
    }
    
    var isEmpty : Bool {
        return movies?.isEmpty ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    private func registerCell() {
        tableView.register(UINib.init(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: CategoryCell.reuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movies?.count ?? 0)
        return isEmpty ? searchTokens.count : (movies?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !isEmpty, let movie = movies?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.bind(movie: movie)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier) as! CategoryCell
        cell.bind(text: searchTokens[indexPath.row].representedObject as! String)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isEmpty {
            onSearchTokenSelected?(searchTokens[indexPath.row])
        }
        
        guard !isEmpty else { return }
        let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
        movieDetailVC.movie = movies?[indexPath.row]
        self.present(movieDetailVC, animated: true, completion: nil)
    }
}
