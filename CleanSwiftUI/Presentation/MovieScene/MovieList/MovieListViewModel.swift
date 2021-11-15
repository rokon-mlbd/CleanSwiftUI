//
//  MovieListViewModel.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Combine
import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: MovieList = .init()
    @Published var page = 1
    @Published var isLoading = false
    @Published var isErrorAlert = false
    @Published var errorMessage = ""
    
    private var bag = Set<AnyCancellable>()
    private let movieListUseCase: MovieListUseCase
    
    init(movieListUseCase: MovieListUseCase) {
        self.movieListUseCase = movieListUseCase
        bindInputs()
        bindOutputs()
    }
    
    deinit {
        bag.removeAll()
    }
    
    // MARK: Input
    enum Input {
        case getMovieList
    }
    
    private let getMovieListSubject = PassthroughSubject<Void, Never>()
    
    private let movieListSubject = PassthroughSubject<MovieList, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    func apply(_ input: Input) {
        switch input {
        case .getMovieList:
            getMovieListSubject.send(())
        }
    }
    
    func bindInputs() {
        getMovieListSubject
            .flatMap { [movieListUseCase] _ in
                movieListUseCase.execute(page: self.page)
                    .catch { [weak self] error -> Empty<MovieList, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .share()
            .subscribe(movieListSubject)
            .store(in: &bag)
        
        getMovieListSubject
            .map { _ in true }
            .share()
            .subscribe(isLoadingSubject)
            .store(in: &bag)
    }
    
    func bindOutputs() {
        isLoadingSubject
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)
        
        movieListSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)
        
        movieListSubject
            .assign(to: \.movies, on: self)
            .store(in: &bag)
        
        errorSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)
        
        errorSubject
            .map { _ in true }
            .assign(to: \.isErrorAlert, on: self)
            .store(in: &bag)
        
        errorSubject
            .map { $0.localizedDescription }
            .assign(to: \.errorMessage, on: self)
            .store(in: &bag)
    }
    
    func checkNextPage(id: Int) {
        if id == page * 25 {
            page += 1
            apply(.getMovieList)
        }
    }
}
