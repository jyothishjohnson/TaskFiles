//
//  FilesGridView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 13/10/24.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct FileItem: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .fileURL) { file in
            SentTransferredFile(file.url)
        } importing: { received in
            let copy = URL(fileURLWithPath: received.file.lastPathComponent)
            do {
                try FileManager.default.copyItem(at: received.file, to: copy)
            } catch (let error) {
                print("###", error.localizedDescription)
            }
            return Self.init(url: copy)
        }
    }
}

struct FilesGridView: View {
    
    @State var task: Task
    @State private var selectedFile: String?
    
    // Define the grid layout
    private let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(task.fileNames.sorted(), id: \.self) { fileName in
                VStack {
                    FileIconView(fileName: fileName)
                        .frame(width: 64, height: 64)
                    Text(fileName)
                        .font(.caption)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding(4)
                .background(selectedFile == fileName ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                .gesture(getGesture(for: fileName))
                .draggable(FileItem(url: fileURL(for: fileName))) {
                    FileIconView(fileName: fileName)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func getGesture(for fileName: String) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                openFile(fileName)
                print("Double tap")
            }
            .simultaneously(with: TapGesture(count: 1)
                .onEnded {
                    print("Single Tap")
                    if selectedFile == fileName {
                        selectedFile = nil
                        print("Deselected file: \(fileName)")
                    } else {
                        selectedFile = fileName
                        print("Selected file: \(fileName)")
                    }
                })
    }
    
    private func openFile(_ fileName: String) {
        guard let filePath = task.filePaths[fileName] else {
            print("File path not found for: \(fileName)")
            return
        }
        
        let didOpen = NSWorkspace.shared.open(URL(fileURLWithPath: filePath))
        print("File opening initiated: \(fileName)")
        print("File Opening success:", didOpen)
    }
    
    private func fileURL(for fileName: String) -> URL {
        guard let filePath = task.filePaths[fileName] else {
            fatalError("File path not found for: \(fileName)")
        }
        return URL(fileURLWithPath: filePath)
    }
}

#Preview {
    FilesGridView(task: Task(name: "Hello"))
}
