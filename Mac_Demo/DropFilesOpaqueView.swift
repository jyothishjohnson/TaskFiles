//
//  DropFilesOpaqueView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 13/10/24.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit


struct DropFilesOpaqueView: View {
    @State var task: Task
    @State private var isTargeted = false
    
    var body: some View {
        Rectangle()
            .fill(isTargeted ? Color.green.opacity(0.3) : Color.clear)
            .frame(height: 100)
            .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isTargeted) { providers -> Bool in
                let _ = providers.first?.loadObject(ofClass: URL.self) { item, error in
                    guard let url = item else { return }
                    
                    do {
                        let fileContent = try Data(contentsOf: url)
                        let fileName = url.lastPathComponent
                        
                        if task.addFileName(fileName) {
                            TaskManager.shared.addFile(to: task.name, fileName: fileName, fileContent: fileContent)
                        }

                    } catch {
                        print("Error reading file: \(error.localizedDescription)")
                    }
                }
                return true
            }
    }
}

#Preview {
    DropFilesOpaqueView(task: Task(name: "Hello"))
}
