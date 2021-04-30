//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    func bind(movie : Movie) {
        posterImageView.image = UIImage(named: "poster-placeholder")
        loadPosterImage(posterUrl : movie.posterUrl)
        titleLabel.text = movie.title
        languageLabel.text = movie.language
        yearLabel.text = movie.year
    }
    
    private func loadPosterImage(posterUrl : String) {
        downloadImage(url: posterUrl) { [weak self] (data) in
            if let data = data, let image = UIImage(data: data) {
                self?.posterImageView.image = image
            }
        }
    }
}
