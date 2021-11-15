//
//  Movie.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation

struct MovieList: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    init(  )  {
        page = 0
        results = []
        totalPages = 0
        totalResults = 0
    }

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    var poster: URL? { posterPath.map { MoviesAPI.imageBase.appendingPathComponent($0) } }

    enum CodingKeys: String, CodingKey {
        case title, id
        case posterPath = "poster_path"
    }
}
