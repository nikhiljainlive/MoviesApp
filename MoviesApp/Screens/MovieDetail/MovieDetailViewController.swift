//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Admin on 30/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var runtimeAndYearLabel: UILabel!
    
    
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var ratingTypeImageView: UIImageView!
    
    @IBOutlet weak var ratingTypeTitleLabel: UILabel!
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    @IBOutlet weak var plotLabel: UILabel!
    
    @IBOutlet weak var castAndCrewLabel: UILabel!
    
    @IBOutlet weak var releasedDateLabel: UILabel!
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (movie != nil) {
            setMovieToViews()
        }
    }
    
    private func setMovieToViews() {
        loadImage()
        initSegmentedControl()
        titleLabel.text = movie?.title
        runtimeAndYearLabel.text = String(format: "%@ | %@", movie!.runtime, movie!.year)
        plotLabel.text = movie!.plot
        castAndCrewLabel.text = movie!.actors
        releasedDateLabel.text = movie!.releasedDate
    }
    
    private func loadImage() {
        downloadImage(url: movie!.posterUrl) { [weak self] (data) in
            if let data = data, let image = UIImage(data: data) {
                self?.posterImageView?.image = image
            }
        }
    }
    
    private func initSegmentedControl() {
        ratingSegmentedControl.removeAllSegments()
        for (index, rating) in movie!.ratings.enumerated() {
            let title = rating.source.localizedCaseInsensitiveCompare("Internet Movie Database") == ComparisonResult.orderedSame ? "IMDb" : rating.source
            ratingSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        if (ratingSegmentedControl.numberOfSegments > 0) {
            
            let rating = movie!.ratings[0]
            ratingSegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
            ratingSegmentedControl.selectedSegmentIndex = 0
            ratingTypeTitleLabel.text = rating.source
            ratingTypeImageView.image = UIImage(named: "imdb")
            ratingValueLabel.text = rating.value
            
            setIMDbRating(rating)
        }
    }
    
    @objc private func segmentedValueChanged(_ sender:UISegmentedControl!) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        
        let selectedIndex = sender.selectedSegmentIndex
        
        let selectedRating = movie!.ratings[selectedIndex]
        let title = selectedRating.source
        ratingTypeTitleLabel.text = title
        ratingValueLabel.text = selectedRating.value
        
        switch title {
        case "Internet Movie Database":
            ratingTypeImageView.image = UIImage(named: "imdb")
            setIMDbRating(selectedRating)
        case "Rotten Tomatoes":
            ratingTypeImageView.image = UIImage(named: "rotten-tomatoes")
            setRottenTomatoesRating(selectedRating)
        case "Metacritic":
            ratingTypeImageView.image = UIImage(named: "metacritic")
            setMetacriticRating(selectedRating)
        default:
            break
        }
    }
    
    private func setIMDbRating(_ selectedRating: Rating) {
        let splittedValues = selectedRating.value.split(separator: "/")
        let ratingValue = Double(splittedValues[0])
        let maxRating = Int(splittedValues[1])
        ratingView.maxRating = (maxRating ?? 0) / 2
        ratingView.rating = (ratingValue ?? 0) / 2
    }
    
    private func setRottenTomatoesRating(_ selectedRating: Rating) {
        let splittedValues = selectedRating.value.split(separator: "%")
        let ratingValue = Double(splittedValues[0])
        ratingView.rating = (ratingValue ?? 0) / 20
    }
    
    private func setMetacriticRating(_ selectedRating: Rating) {
        let splittedValues = selectedRating.value.split(separator: "/")
        let ratingValue = Double(splittedValues[0])
        let maxRating = Int(splittedValues[1])
        ratingView.maxRating = (maxRating ?? 0) / 20
        ratingView.rating = (ratingValue ?? 0) / 20
    }
}
