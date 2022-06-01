//
//  ContactLensesApp.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 01/10/2021.
//

import SwiftUI

@main
struct ContactLensesApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @ObservedObject private var context = AppContext()
    
    var body: some Scene {
        let viewContext = persistenceController.container.viewContext
        WindowGroup {
            NavigationView {
                PairsListView()
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(context)
            }
            .alert(item: $context.presentedAlert) {
                switch $0 {
                case .deletePair(let pairs):
                    return Alert(
                        title: Text("Delete?"),
                        message: Text("This action is irreversible"),
                        primaryButton: .destructive(Text("Delete")) {
                            pairs.forEach(viewContext.delete)
                            try? viewContext.save()
                        },
                        secondaryButton: .cancel()
                    )
                case .notificationPrompt:
                    return Alert(
                        title: Text("Push notifications disabled"),
                        message: Text("Replacement reminders cannot be sent if this setting is disabled")
                    )
                }
            }
            .sheet(item: $context.presentedSheet) {
                switch $0 {
                case .editPair(let pair):
                    NavigationView {
                        PairEditView(pair)
                            .environment(\.managedObjectContext, viewContext)
                    }
                case .settings:
                    NavigationView {
                        SettingsView()
                            .environmentObject(context)
                    }
                }
            }
        }
    }
    
}
