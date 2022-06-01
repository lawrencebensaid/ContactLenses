//
//  PairsListView.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 01/10/2021.
//

import SwiftUI
import CoreData

struct PairsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode
    
    @EnvironmentObject private var context: AppContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Pair.startAt, ascending: false)], animation: .default)
    private var items: FetchedResults<Pair>

    var body: some View {
        List {
            ForEach(items) { pair in
                PairItemView(pair)
                    .contextMenu { contextMenu(for: pair) }
                    .swipeActions(edge: .leading) {
                        Button("Edit") {
                            context.present(.editPair(pair))
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            context.present(.deletePair([pair]))
                        }
                        .tint(.red)
                    }
            }
        }
        .onAppear {
            let pairs = try? viewContext.fetch(Pair.fetchRequest())
            LocalNotification.remove(.all)
            for pair in pairs ?? [] {
                LocalNotification(body: "Replacement needed").schedule(pair.endAt)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Divider()
                    Button {
                        context.present(.settings)
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    @ViewBuilder
    private func contextMenu(for pair: Pair) -> some View {
        Button {
            context.present(.editPair(pair))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        Button(role: .destructive) {
            context.present(.deletePair([pair]))
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    

    private func addItem() {
        let last = items.first?.copy()
        let pair: Pair = last ?? Pair(context: viewContext)
        pair.startAt = Date()
        pair.endAt = Date().addingTimeInterval(30 * 24 * 60 * 60)
        if last == nil {
            pair.left = Lens(context: viewContext)
            pair.right = Lens(context: viewContext)
        }
        context.present(.editPair(pair))
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PairsListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
