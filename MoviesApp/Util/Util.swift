//
//  Util.swift
//  MoviesApp
//
//  Created by Admin on 01/05/21.
//

import Foundation

func downloadImage(url : String, completion : @escaping (Data?) -> Void) {
    DispatchQueue.global().async {
        if let url = URL(string: url), let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                completion(data)
                return
            }
        }
        completion(nil)
    }
}
