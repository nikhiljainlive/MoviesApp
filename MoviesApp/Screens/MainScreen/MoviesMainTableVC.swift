//
//  ViewController.swift
//  MoviesApp
//
//  Created by Admin on 28/04/21.
//

import UIKit

class MoviesMainTableVC: UITableViewController {
    private let movies = MovieDataSourceImpl.shared.getAllMovies()
    private var searchController : UISearchController!
    private var moviesTableVC : MoviesTableViewController!
    
    private var isSearchingByTokens: Bool {
      return
        searchController.isActive &&
        searchController.searchBar.searchTextField.tokens.count > 0
    }
    
    private var searchCategory : MovieSearchCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGlobals()
        registerCell()
    }
    
    private func initGlobals() {
        moviesTableVC = storyboard?.instantiateViewController(withIdentifier: "MoviesTableVC") as? MoviesTableViewController
        moviesTableVC.onSearchTokenSelected = self.onSearchTokenSelected
        searchController = UISearchController(searchResultsController: moviesTableVC)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func onSearchTokenSelected(searchToken : UISearchToken) {
        let searchTextField = searchController.searchBar.searchTextField
        searchTextField.tokens.removeAll()
        searchTextField.insertToken(searchToken, at: searchTextField.tokens.count)
        searchCategory = MovieSearchCategory.init(rawValue: (searchToken.representedObject as? String) ?? "")
        searchFor(searchController.searchBar.text)
        showScopeBar(true)
    }
    
    private func registerCell() {
        tableView.register(UINib.init(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
        cell.bind(movie: movies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieDetailVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
        movieDetailVC.movie = movies[indexPath.row]
        self.present(movieDetailVC, animated: true, completion: nil)
    }
    
    func searchFor(_ searchText: String?) {
        guard searchController.isActive else { return }
        guard let searchText = searchText else {
            moviesTableVC.movies = nil
            return
        }
        
        if isSearchingByTokens {
            let filteredMovies = MovieDataSourceImpl.shared.searchMovies(searchString: searchText, category: searchCategory)
            moviesTableVC.movies =
                filteredMovies.count > 0 ? filteredMovies : nil
            return
        }
        
        searchCategory = nil
        let filteredMovies = MovieDataSourceImpl.shared.searchMovies(searchString: searchText, category: searchCategory)
        moviesTableVC.movies =
            filteredMovies.count > 0 ? filteredMovies : nil
    }
    
    func showScopeBar(_ show: Bool) {
        guard searchController.searchBar.showsScopeBar != show else { return }
        searchController.searchBar.setShowsScope(show, animated: true)
        view.setNeedsLayout()
    }
}

extension MoviesMainTableVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchController.searchBar.text else { return }
        searchFor(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFor(searchText)
        let showScope = !searchText.isEmpty
        showScopeBar(showScope)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        moviesTableVC.movies = nil
        showScopeBar(false)
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
}

extension MoviesMainTableVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.searchTextField.isFirstResponder {
            searchController.showsSearchResultsController = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        } else {
            searchController.searchBar.searchTextField.backgroundColor = nil
        }
    }
}
