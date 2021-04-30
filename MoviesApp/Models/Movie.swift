//
//  Movie.swift
//  MoviesApp
//
//  Created by Admin on 28/04/21.
//

import Foundation

struct Movie : Codable {
    let posterUrl : String
    let title : String
    let plot : String
    let language : String
    let year : String
    let actors : String
    let ratings : [Rating]
    let directors : String
    let genre : String
    let runtime : String
    let releasedDate : String
    
    enum CodingKeys: String, CodingKey {
        case posterUrl = "Poster"
        case title = "Title"
        case plot = "Plot"
        case language = "Language"
        case year = "Year"
        case actors = "Actors"
        case ratings = "Ratings"
        case directors = "Director"
        case genre = "Genre"
        case runtime = "Runtime"
        case releasedDate = "Released"
    }
}

struct Rating : Codable {
    let source : String
    let value : String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
