//
//  TodayView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import SwiftUI

struct TodayView: View {
    @State private var tasks = [Task]()
    @State private var newTaskName = ""

    var body: some View {
        VStack {
            List(tasks) { task in
                Text(task.name)
            }
            TextField("What's on your mind?!!", text: $newTaskName)
                .onSubmit {
                    addTask()
                }
        }
    }

    private func addTask() {
        let trimmedName = newTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            let newTask = Task(name: trimmedName)
            tasks.append(newTask)
            newTaskName = ""
        }        
    }
}

#Preview {
    TodayView()
}

struct Task: Identifiable {
    let id = UUID()
    private(set) var name: String
    private(set) var isArchived: Bool
    private(set) var fileNames: [String]
    
    init(name: String, isArchived: Bool = false) {
        self.name = name
        self.isArchived = isArchived
        self.fileNames = []
    }
    
    mutating func addFileName(_ fileName: String) {
        fileNames.append(fileName)
    }
}
