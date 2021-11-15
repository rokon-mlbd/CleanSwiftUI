//
//  CleanSwiftUIApp.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/13/21.
//

import SwiftUI

@main
struct CleanSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            DependencyInjection.shared.getMovieListView()
        }
    }
}
