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
    func getAllMovieYears() -> [String]
    func getAllMovieGenres() -> [String]
    func getAllMovieDirectors() -> [String]
    func getAllMovieActors() -> [String]
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
//                return !movie.getActorsList().filter { (actor) -> Bool in
//                    actor.localizedCaseInsensitiveContains(searchString)
//                }.isEmpty
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
    
    func getAllMovieGenres() -> [String] {
        return movies.map { $0.getGenresList() }.flatMap { $0 }.unique()
    }
    
    func getAllMovieDirectors() -> [String] {
        return movies.map { $0.getDirectorsList() }.flatMap { $0 }.unique()
    }
    
    func getAllMovieActors() -> [String] {
        return movies.map { $0.getActorsList() }.flatMap { $0 }.unique()
    }
    
    func getAllMovieYears() -> [String] {
        return movies.map { $0.year }.unique()
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
