//
//  ViewController.swift
//  MoviesApp
//
//  Created by Admin on 28/04/21.
//

import UIKit

class MoviesCategoryTableVC: UITableViewController {
    private let categories = MovieSearchCategory.allCases.map { $0.rawValue }
    private var searchController : UISearchController!
    private var moviesTableVC : ItemsTableViewController<MovieTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGlobals()
        registerCell()
    }
    
    private func initGlobals() {
        moviesTableVC = ItemsTableViewController<MovieTableViewCell>()
        moviesTableVC.defaultItems = MovieDataSourceImpl.shared.getAllMovies()
        moviesTableVC.onItemSelected = { [weak self] movie in
            let movieDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
            movieDetailVC.movie = movie
            self?.navigationController?.pushViewController(movieDetailVC, animated: true)
        }
        searchController = UISearchController(searchResultsController: moviesTableVC)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func registerCell() {
        tableView.register(UINib.init(nibName: CategoryInfoCell.nibName, bundle: nil), forCellReuseIdentifier: CategoryInfoCell.reuseIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryInfoCell.reuseIdentifier) as! CategoryInfoCell
        cell.bind(item: categories[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedCategory = MovieSearchCategory.init(rawValue: categories[indexPath.row]) else {
            return
        }
        
        let categoryItemsController = ItemsTableViewController<CategoryInfoCell>()
        
        switch selectedCategory {
            case .year : categoryItemsController.defaultItems = MovieDataSourceImpl.shared.getAllMovieYears()
            
            case .genre : categoryItemsController.defaultItems = MovieDataSourceImpl.shared.getAllMovieGenres()

            case .directors : categoryItemsController.defaultItems = MovieDataSourceImpl.shared.getAllMovieDirectors()
                
            case .actors : categoryItemsController.defaultItems = MovieDataSourceImpl.shared.getAllMovieActors()
        }
        setItemSelection(for : categoryItemsController, selectedCategory: selectedCategory)
        self.navigationController?.pushViewController(categoryItemsController, animated: true)
        
    }
    
    private func setItemSelection(for categoryItemsController: ItemsTableViewController<CategoryInfoCell>, selectedCategory : MovieSearchCategory) {
        categoryItemsController.onItemSelected = { [weak self] selectedItem in
            let moviesController = ItemsTableViewController<MovieTableViewCell>()
            moviesController.defaultItems = MovieDataSourceImpl.shared.searchMovies(searchString: selectedItem, category: selectedCategory)
            moviesController.onItemSelected = { movie in
                let movieDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
                movieDetailVC.movie = movie
                self?.navigationController?.pushViewController(movieDetailVC, animated: true)
            }
            self?.navigationController?.pushViewController(moviesController, animated: true)
        }
    }
    
    func searchFor(_ searchText: String?) {
        guard searchController.isActive else { return }
        guard let searchText = searchText else {
            moviesTableVC.items = nil
            return
        }
        
        let filteredMovies = MovieDataSourceImpl.shared.searchMovies(searchString: searchText, category: nil)
        moviesTableVC.items =
            filteredMovies.count > 0 ? filteredMovies : nil
    }
    
    func showScopeBar(_ show: Bool) {
        guard searchController.searchBar.showsScopeBar != show else { return }
        searchController.searchBar.setShowsScope(show, animated: true)
        view.setNeedsLayout()
    }
}

extension MoviesCategoryTableVC : UISearchBarDelegate {
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
        moviesTableVC.items = nil
        showScopeBar(false)
        searchController.searchBar.searchTextField.backgroundColor = nil
    }
}

extension MoviesCategoryTableVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.searchTextField.isFirstResponder {
            searchController.showsSearchResultsController = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        } else {
            searchController.searchBar.searchTextField.backgroundColor = nil
        }
    }
}
