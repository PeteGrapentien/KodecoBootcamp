//
//  TaskListTranslationApp.swift
//  TaskListTranslation
//
//  Created by Peter Grapentien on 10/4/24.
//

import SwiftUI

@main
struct TaskListTranslationApp: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(viewModel)
        }
    }
}
