//
//  ContentView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import SwiftUI
import SwiftData

enum SideBarView: String, CaseIterable {
    case today = "Today"
    case archive = "Archive"
    case settings = "Settings"
    
    var labelImage: String {
        switch self {
        case .today:
            "list.bullet.clipboard"
        case .archive:
            "archivebox"
        case .settings:
            "gear"
        }
    }
}

struct ContentView: View {
    let sidebars : [SideBarView] = SideBarView.allCases
    @State private var selection: SideBarView = .today

    var body: some View {
        NavigationSplitView {
            List(sidebars, id: \.self, selection: $selection) { view in
                Label(view.rawValue, systemImage: view.labelImage)
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                
            }
        } detail: {
            Text(selection.rawValue).italic()
        }
    }
}

#Preview {
    ContentView()
}
