//
//  ViewModel.swift
//  TaskListTranslation
//
//  Created by Peter Grapentien on 10/4/24.
//
import Foundation
import Translation
import SwiftUI

@Observable
class ViewModel {
    
    var taskItems: [TaskItem]
    
    var availableLanguages: [AvailableLanguage] = []
    
    var translateFrom: Locale.Language?
    var translateTo: Locale.Language?
    var isTranslationSupported: Bool?
    
    
    var translationBatch: [TranslationSession.Request] {
        let visibleTasks = taskItems
        return visibleTasks.map { task in
            TranslationSession.Request(sourceText: task.text, clientIdentifier: task.id)
        }
    }
    
    init() {
        taskItems = [
            TaskItem(title: "Groceries", id: "1"),
            TaskItem(title: "Homework", id: "2"),
            TaskItem(title: "Take Kids to Preschool", id: "3"),
            TaskItem(title: "Exercise", id: "4")]
        prepareSupportedLanguages()
    }
    
    init(taskItems: [TaskItem]) {
        self.taskItems = taskItems
    }
    
    func translateAll() {
        print("Do something here.")
    }
    
    func prepareSupportedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map {
                AvailableLanguage(locale: $0)
            }.sorted()
        }
    }
    
    func checkLanguageSupport(from source: Locale.Language, to target: Locale.Language) async {
        translateFrom = source
        translateTo = target
        
        guard let translateFrom = translateFrom else { return }
        
        let status = await LanguageAvailability().status(from: translateFrom, to: translateTo)
        
        switch status {
        case .installed, .supported:
            isTranslationSupported = true
        case .unsupported:
            isTranslationSupported = false
        @unknown default:
            print("Translation support status for the selected language pair is unknown")
        }
    }
    
    func translate(session: TranslationSession) async {
        let tasks = taskItems.compactMap { $0.text }
        let requests: [TranslationSession.Request] = tasks.enumerated().map { (index, string) in
                .init(sourceText: string, clientIdentifier: "\(index)")
        }
        
        do {
            for try await response in session.translate(batch: requests) {
                guard let index = Int(response.clientIdentifier ?? "") else { continue }
                taskItems[index].text = response.targetText
            }
        } catch {
            print("Error executing translateSequence: \(error)")
        }
    }
}
