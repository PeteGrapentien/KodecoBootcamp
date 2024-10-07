//
//  ContentView.swift
//  TaskListTranslation
//
//  Created by Peter Grapentien on 10/4/24.
//

import SwiftUI
import Translation

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    @State var configuration: TranslationSession.Configuration?
    @State var sourceLanguage: Locale.Language?
    @State var showTranslation = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.taskItems) { taskItem in
                        Text(taskItem.text).font(.title)
                    }
            }.navigationTitle("Task List")
            .translationTask(configuration) { session in
                        Task {
                            await viewModel.translate(session: session)
                        }
                    }
            Button("Translate", action: {
                translateAll()
                    }).font(.title)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                            NavigationLink("Choose Language", destination: ChooseLanguageView())
                        }
                }
            }
        }
    }
    private func translateAll() {
        configuration = .init(source: viewModel.translateFrom, target: viewModel.translateTo)
    }
}

#Preview {
    ContentView()
}
