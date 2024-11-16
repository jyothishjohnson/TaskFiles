//
//  TodayView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    TodayView()
}

struct Task {
    private(set) var name: String
    private(set) var isArchived: Bool
    private(set) var fileNames: [String]
    
    init(name: String, isArchived: Bool = false) {
        self.name = name
        self.isArchived = isArchived
        self.fileNames = []
    }
}
