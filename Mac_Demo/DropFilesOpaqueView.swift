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
        RoundedRectangle(cornerRadius: 12)
            .fill(isTargeted ? Color.blue.opacity(0.1) : Color.clear)
            .frame(minHeight: 100)
            .overlay {
                if !isTargeted && task.fileNames.isEmpty {
                    Text("Drop your files here")
                        .foregroundStyle(.gray)
                }
            }
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
