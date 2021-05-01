//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell, TableViewBindableCell {
    typealias Item = Movie
    
    static let reuseIdentifier = "MovieTableViewCell"
    
    static let nibName: String = "MovieTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    func bind(item : Movie) {
        posterImageView.image = UIImage(named: "poster-placeholder")
        loadPosterImage(posterUrl : item.posterUrl)
        titleLabel.text = item.title
        languageLabel.text = item.language
        yearLabel.text = item.year
    }
    
    private func loadPosterImage(posterUrl : String) {
        downloadImage(url: posterUrl) { [weak self] (data) in
            if let data = data, let image = UIImage(data: data) {
                self?.posterImageView.image = image
            }
        }
    }
}
