//
//  MovieListView.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Kingfisher
import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.movies.results, id: \.id) { movie in
                        ZStack {
                            MovieListRow(movie: movie)
                                .onAppear {
                                    viewModel.checkNextPage(id: viewModel.movies.page)
                                }
                            
                            NavigationLink(
                                destination: DependencyInjection.shared.getMovieDetailViewForId(movie.id)) {}
                            
                        }
                    }
                    
                }.listStyle(PlainListStyle())
                ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
            }
            
            .alert(isPresented: $viewModel.isErrorAlert) {
                Alert(title: Text(""), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Trending Movies", displayMode: .large)
        }
        .onAppear {
            viewModel.apply(.getMovieList)
        }
    }
}


struct MovieListRow: View {
    let movie: Movie
    
    
    var body: some View {
        VStack {
            title
            KFImage(URL(string: movie.poster?.absoluteString ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(idealHeight: UIFrame.width / 2 * 3) // 2:3 aspect ratio
        }
    }
    
    private var title: some View {
        Text(movie.title)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieListViewModel(movieListUseCase: DefaultMovieListUseCase(repository: DefaultMovieListRepository())))
    }
}


