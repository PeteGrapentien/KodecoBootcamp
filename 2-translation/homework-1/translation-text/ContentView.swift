//
//  ContentView.swift
//  translation-text
//
//  Created by Peter Grapentien on 10/3/24.
//

import SwiftUI
import Translation

struct ContentView: View {
    @State private var showTranslation = false
    @State private var welcomeText = "Welcome! This is an app that greets you in whatever language you like. Click the translate button to see a translation of this paragraph."
    
    var body: some View {
        VStack {
            
            Text(welcomeText)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            Button("Translate",
                   action: { showTranslation.toggle() })
            .buttonStyle(.borderedProminent)
        }
        .translationPresentation(isPresented: $showTranslation,
                                 text: welcomeText) { translatedString in
            welcomeText = translatedString
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
