//
//  MovieDataSource.swift
//  MoviesApp
//
//  Created by Admin on 28/04/21.
//

import Foundation

protocol MovieDataSource {
    func searchMovies(searchString : String, category : MovieSearchCategory?) -> [Movie]
    func getAllMovies() -> [Movie]
}

class MovieDataSourceImpl : MovieDataSource {
    private init() {}

    static let shared : MovieDataSource = MovieDataSourceImpl()
    
    private lazy var movies : [Movie] = {
        let jsonDecoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json"), let data = try? Data(contentsOf: url), let array = try? jsonDecoder.decode(Array<Movie>.self, from: data)
        else {
            return []
        }
        
        return array
    }()
    
    func searchMovies(searchString: String, category : MovieSearchCategory? = nil) -> [Movie] {
        func isMovieFound(movie : Movie) -> Bool {
            switch category {
            case .actors:
                return movie.actors.localizedCaseInsensitiveContains(searchString)
                
            case .directors: return movie.directors.localizedCaseInsensitiveContains(searchString)
                
            case .year: return movie.year.localizedCaseInsensitiveContains(searchString)
                
            case.genre: return movie.genre.localizedCaseInsensitiveContains(searchString)
            
            default:
                return movie.title.localizedCaseInsensitiveContains(searchString) || movie.directors.localizedCaseInsensitiveContains(searchString) || movie.year.localizedCaseInsensitiveContains(searchString) || movie.genre.localizedCaseInsensitiveContains(searchString)
            }
        }
        
        return movies.filter { isMovieFound(movie : $0) }
    }
    
    func getAllMovies() -> [Movie] {
        return movies
    }
}
