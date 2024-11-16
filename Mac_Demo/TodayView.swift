//
//  TodayView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit

@Observable
class TodayTasks {
    var tasks: [Task] = []
}

struct TodayView: View {
    @State private var todayTasks = TodayTasks()
    @State private var newTaskName = ""

    var body: some View {
        VStack {
            List(todayTasks.tasks) { task in
                TaskView(task: task)
                    .listRowSeparator(.hidden)
            }
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                TextField("What's on your mind?!!", text: $newTaskName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 14))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.textBackgroundColor))
                            .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onSubmit {
                        addTask()
                    }
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                    .rotationEffect(Angle(degrees: 45))
                    .onTapGesture {
                        addTask()
                    }
            }
            .padding(.top, 4)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }

    private func addTask() {
        let trimmedName = newTaskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            let newTask = Task(name: trimmedName)
            todayTasks.tasks.append(newTask)
            TaskManager.shared.createTask(name: newTask.name)
            newTaskName = ""
        }
    }
}

#Preview {
    TodayView()
}

@Observable
class Task: Identifiable {
    let id = UUID()
    private(set) var name: String
    private(set) var isArchived: Bool
    private(set) var fileNames: [String]
    
    init(name: String, isArchived: Bool = false) {
        self.name = name
        self.isArchived = isArchived
        self.fileNames = []
    }
    
    func addFileName(_ fileName: String) {
        fileNames.append(fileName)
    }
}

struct TaskView: View {
    @State var task: Task
    @State private var isTargeted = false
    
    var body: some View {
        VStack {
            HStack {
                Text(task.name.uppercased())
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            ForEach(task.fileNames, id: \.self) { file in
                HStack {
                    FileIconView(fileName: file)
                        .frame(width: 32, height: 32)
                    Text(file)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            Rectangle()
                .fill(isTargeted ? Color.green.opacity(0.3) : Color.gray.opacity(0.3))
                .frame(height: 100)
                .overlay(
                    Text("Drop files here")
                        .foregroundColor(.secondary)
                )
                .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isTargeted) { providers -> Bool in
                    let _ = providers.first?.loadObject(ofClass: URL.self) { item, error in
                        guard let url = item else { return }
                        
                        do {
                            let fileContent = try Data(contentsOf: url)
                            let fileName = url.lastPathComponent
                            
                            if TaskManager.shared.addFile(to: task.name, fileName: fileName, fileContent: fileContent) {
                                task.addFileName(fileName)
                            }
                        } catch {
                            print("Error reading file: \(error.localizedDescription)")
                        }
                    }
                    return true
                }
        }
        .padding()
        .background(Color(.windowBackgroundColor).opacity(0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct FileIconView: View {
    let fileName: String
    
    var body: some View {
        Image(nsImage: getIconForFile(fileName: fileName))
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func getIconForFile(fileName: String) -> NSImage {
        let workspace = NSWorkspace.shared
        let icon: NSImage
        
        let fileExtension = URL(fileURLWithPath: fileName).pathExtension
        if let fileType = UTType(filenameExtension: fileExtension) {
            icon = workspace.icon(for: fileType)
        } else {
            icon = workspace.icon(forFile: "public.data")
        }
        
        return icon
    }
}
