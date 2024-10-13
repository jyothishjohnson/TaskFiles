//
//  TaskManager.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import Foundation

class TaskManager {
    static let shared = TaskManager()
    
    private let fileManager = FileManager.default
    private var myTasksDirectory: URL?
    
    private init() {
        setupMyTasksDirectory()
    }
    
    private func setupMyTasksDirectory() {
        let homeDirectory = fileManager.homeDirectoryForCurrentUser
        let documentsDirectory = homeDirectory.appendingPathComponent("Documents")
        myTasksDirectory = documentsDirectory.appendingPathComponent("MyTasks")
        
        do {
            try fileManager.createDirectory(at: myTasksDirectory!, withIntermediateDirectories: true, attributes: nil)
            print("MyTasks directory created successfully: \(myTasksDirectory!.path)")
        } catch {
            print("Error creating MyTasks directory: \(error.localizedDescription)")
        }
    }
    
    @discardableResult
    func createTask(name: String) -> Bool {
        guard let myTasksDirectory = myTasksDirectory else {
            print("MyTasks directory not set up")
            return false
        }
        
        let taskFolderURL = myTasksDirectory.appendingPathComponent(name)
        do {
            try fileManager.createDirectory(at: taskFolderURL, withIntermediateDirectories: true, attributes: nil)
            print("Task folder created successfully: \(taskFolderURL.path)")
            return true
        } catch {
            print("Error creating task folder: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func addFile(to taskName: String, fileName: String, fileContent: Data) -> Bool {
        guard let myTasksDirectory = myTasksDirectory else {
            print("MyTasks directory not set up")
            return false
        }
        
        let taskFolderURL = myTasksDirectory.appendingPathComponent(taskName)
        let fileURL = taskFolderURL.appendingPathComponent(fileName)
        
        do {
            try fileContent.write(to: fileURL)
            print("File added successfully: \(fileURL.path)")
            return true
        } catch {
            print("Error adding file: \(error.localizedDescription)")
            return false
        }
    }
}
