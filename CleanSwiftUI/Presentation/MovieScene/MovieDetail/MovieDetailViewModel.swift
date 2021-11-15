//
//  MovieDetailViewModel.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

//
//  MovieDetailViewModel.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Combine
import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail = .init()
    @Published var isLoading = false
    @Published var isErrorAlert = false
    @Published var errorMessage = ""

    private var bag = Set<AnyCancellable>()
    private let movieListUseCase: MovieDetailUseCase

    init(movieListUseCase: MovieDetailUseCase) {
        self.movieListUseCase = movieListUseCase
        bindInputs()
        bindOutputs()
    }
    
    deinit {
        bag.removeAll()
    }

    // MARK: Input

    enum Input {
        case getMovieDetail(id: Int)
    }

    private let getMovieDetailSubject = PassthroughSubject<Int, Never>()

    private let movieSubject = PassthroughSubject<MovieDetail, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    func apply(_ input: Input) {
        switch input {
        case .getMovieDetail(let id):
            getMovieDetailSubject.send(id)
        }
    }

    func bindInputs() {
        getMovieDetailSubject
            .flatMap { [movieListUseCase] id in
                movieListUseCase.execute(movieId: id) // need to fix
                    .catch { [weak self] error -> Empty<MovieDetail, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .share()
            .subscribe(movieSubject)
            .store(in: &bag)

        getMovieDetailSubject
            .map { _ in true }
            .share()
            .subscribe(isLoadingSubject)
            .store(in: &bag)
    }

    func bindOutputs() {
        isLoadingSubject
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        movieSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        movieSubject
            .assign(to: \.movieDetail, on: self)
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
}

