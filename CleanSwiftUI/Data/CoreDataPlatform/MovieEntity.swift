//
//  MovieEntity.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/13/21.
//

import Foundation
import CoreData

extension Movie {
    func toEntity(in context: NSManagedObjectContext) -> MovieEntity {
        let entity: MovieEntity = .init(context: context)
        entity.id = Int16(id ?? 0)
        entity.title = title
        entity.posterPath = posterPath
        return entity
    }
}

extension MovieEntity {
    var asDomain: Movie {
        return .init(id: Int(id), title: title ?? "", posterPath: posterPath)
    }
}

