//
//  Untitled.swift
//  TaskListTranslation
//
//  Created by Peter Grapentien on 10/4/24.
//

import Foundation

struct TaskItem: Identifiable {
    public var text: String
    public var id: String
    
    init(title: String, id: String) {
        self.text = title
        self.id = id
    }
}
