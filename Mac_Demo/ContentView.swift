//
//  ContentView.swift
//  Mac_Demo
//
//  Created by jyothish.johnson on 10/10/24.
//

import SwiftUI
import SwiftData

enum SideBarViews: String, CaseIterable {
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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selection: String? = "Inbox"
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(SideBarViews.allCases, id: \.self) { view in
                    NavigationLink {
                        Text(view.rawValue).italic()
                    } label: {
                        Label(view.rawValue, systemImage: view.labelImage)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
