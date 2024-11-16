//
//  FilesGridView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 13/10/24.
//

import SwiftUI

struct FilesGridView: View {
    
    @State var task: Task
    @State private var selectedFile: String?
    
    // Define the grid layout
    private let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            ForEach(task.fileNames.sorted(), id: \.self) { file in
                VStack {
                    FileIconView(fileName: file)
                        .frame(width: 64, height: 64)
                    Text(file)
                        .font(.caption)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .padding(4)
                .background(selectedFile == file ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                .onTapGesture {
                    if selectedFile == file {
                        selectedFile = nil
                        print("Deselected file: \(file)")
                    } else {
                        selectedFile = file
                        print("Selected file: \(file)")
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FilesGridView(task: Task(name: "Hello"))
}
