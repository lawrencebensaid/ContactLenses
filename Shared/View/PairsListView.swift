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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LensPair.startAt, ascending: false)], animation: .default)
    private var pairs: FetchedResults<LensPair>

    var body: some View {
        Group {
            if pairs.isEmpty {
                VStack(spacing: 12) {
                    Text("No schedule")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Button {
                        editNewPair()
                    } label: {
                        Text("Add lenses")
                    }
                }
            } else {
                List {
                    ForEach(pairs) { pair in
                        PairItemView(pair)
                            .contextMenu { contextMenu(for: pair) }
                            .swipeActions(edge: .leading) {
                                Button("Edit") {
                                    context.present(.editPair(pair))
                                }
                                .disabled(pairs.isEmpty)
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
            }
        }
        .onAppear {
            let pairs = try? viewContext.fetch(LensPair.fetchRequest())
            LocalNotification.remove(.all)
            for pair in pairs ?? [] {
                LocalNotification(body: "Replacement needed").schedule(pair.endAt)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        editNewPair()
                    } label: {
                        Label("Add lenses", systemImage: "plus")
                    }
                    Button {
                        editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(pairs.isEmpty)
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
        }
    }
    
    @ViewBuilder
    private func contextMenu(for pair: LensPair) -> some View {
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

    private func editNewPair() {
        let last = pairs.first?.copy()
        let pair: LensPair = last ?? LensPair(context: viewContext)
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
