//
//  ChooseTranslationView.swift
//  TaskListTranslation
//
//  Created by Peter Grapentien on 10/4/24.
//

import SwiftUI

struct ChooseLanguageView: View {
    @Environment(ViewModel.self) var viewModel
    
    @State private var selectedFrom: Locale.Language?
    @State private var selectedTo: Locale.Language?
    
    var selectedLanguagePair: LanguagePair {
        LanguagePair(selectedFrom: selectedFrom, selectedTo: selectedTo)
    }
    
    var body: some View {
        VStack {
            Text("Choose a Language")
            List {
                Picker("Source", selection: $selectedFrom) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }
                Picker("Target", selection: $selectedTo) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }
            }
            HStack {
                Spacer()
                if let isSupported = viewModel.isTranslationSupported {
                    Text(isSupported ? "This language is supported" : "This language is not supported")
                        .font(.largeTitle)
                    if !isSupported {
                        Text("Translation between same language isn't supported.")
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                }
                Spacer()
            }
        }.onChange(of: selectedLanguagePair) {
            Task {
                await performCheck()
            }
        }
        .onDisappear() {
            viewModel.isTranslationSupported = nil
        }
    }
    
    private func performCheck() async {
        guard let selectedFrom = selectedFrom else { return }
        guard let selectedTo = selectedTo else { return }

        await viewModel.checkLanguageSupport(from: selectedFrom, to: selectedTo) //Adds selected languages to viewmodel
    }
}

struct LanguagePair: Equatable {
    @State var selectedFrom: Locale.Language?
    @State var selectedTo: Locale.Language?

    static func == (lhs: LanguagePair, rhs: LanguagePair) -> Bool {
        return lhs.selectedFrom == rhs.selectedFrom &&
        lhs.selectedTo == rhs.selectedTo
    }
}
