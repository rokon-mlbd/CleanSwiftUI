//
//  CoreDataManager.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/13/21.
//

import CoreData
import Combine

protocol LocalManager {
    func saveMovie(movie: Movie)
    func getLocalMovieList(page: Int) -> AnyPublisher<[Movie], NetworkingError>
    func searchLocalID(id: Int) -> AnyPublisher<[Movie], NetworkingError>
    func localRandom() -> AnyPublisher<[Movie], NetworkingError>
}

class CoreDataManager: LocalManager {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func getLocalMovieList(page: Int) -> AnyPublisher<[Movie], NetworkingError> {
        var movies = [Movie]()
        for i in (page - 1) * 25 + 1 ... page * 25  {
            let predicate = NSPredicate(format: "id = %d", i)
            if let movieEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [MovieEntity] {
                for movie in movieEntity {
                    movies.append(movie.asDomain)
                }
            }
        }

        if movies.isEmpty {
            return Fail(error: NetworkingError.defaultError)
                .eraseToAnyPublisher()
        } else {
            return Just(movies)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }
    }

    func searchLocalID(id: Int) -> AnyPublisher<[Movie], NetworkingError> {
        var movies = [Movie]()
        let predicate = NSPredicate(format: "id = %d", id)
        if let movieEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [MovieEntity] {
            if !movieEntity.isEmpty { movies.append(movieEntity.first!.asDomain)}
        }

        if movies.isEmpty {
            return Fail(error: NetworkingError.defaultError)
                .eraseToAnyPublisher()
        } else {
            return Just(movies)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }
    }

    func localRandom() -> AnyPublisher<[Movie], NetworkingError> {
        var movies = [Movie]()
        let id = Int.random(in: 0...10)
        let predicate = NSPredicate(format: "id CONTAINS[cd] %d", id)
        if let movieEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [MovieEntity] {
            if !movieEntity.isEmpty { movies.append(movieEntity.first!.asDomain)}
        }

        if movies.isEmpty {
            return Fail(error: NetworkingError.defaultError)
                .eraseToAnyPublisher()
        } else {
            return Just(movies)
                .setFailureType(to: NetworkingError.self)
                .eraseToAnyPublisher()
        }
    }

    func saveMovie(movie: Movie) {
        self.persistentContainer.performBackgroundTask { context in
            do {
                self.deleteResponse(id: movie.id ?? 0, in: context)

                _ = movie.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension CoreDataManager {

    func fetchRequest(id: Int) -> NSFetchRequest<MovieEntity> {
        let request: NSFetchRequest = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        return request
    }

    private func deleteResponse(id: Int, in context: NSManagedObjectContext) {
        let request = fetchRequest(id: id)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }

}

extension NSManagedObjectContext {

    func fetchData(predicate: NSPredicate? = nil) -> Array<Any> {
        let request: NSFetchRequest = MovieEntity.fetchRequest()
        request.returnsObjectsAsFaults = false

        // If predicate found then filter based on that
        if let predicate = predicate {
            request.predicate = predicate
        }
        do {
            let result = try self.fetch(request)
            return result
        } catch {
            fatalError("Failed to fetch MovieEntity: \(error)")
        }
    }
}


