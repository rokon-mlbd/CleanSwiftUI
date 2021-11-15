//
//  MovieDetail.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let genres: [Genre]
    let release_date: String?
    let runtime: Int?
    let spoken_languages: [Language]

    init() {
        id = 0
        title = ""
        overview = nil
        poster_path = nil
        vote_average = nil
        genres = []
        release_date = nil
        runtime = nil
        spoken_languages = []
    }

    var poster: URL? { poster_path.map { MoviesAPI.imageBase.appendingPathComponent($0) } }

    struct Genre: Codable {
        let id: Int
        let name: String
    }

    struct Language: Codable {
        let name: String
    }
}

extension MovieDetail {
    var getGeners: [String] {
        return genres.map(\.name)
    }

    var getReleasedAt: String {
        return release_date ?? "N/A"
    }

    var getLanguage: String {
        return spoken_languages.first?.name ?? "N/A"
    }

    var getDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.minute, .hour]
        return runtime.flatMap { formatter.string(from: TimeInterval($0 * 60)) } ?? "N/A"
    }

    var getRating: String? {
        return vote_average.map {"⭐️ \(String($0))/10"}
    }
}
