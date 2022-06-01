//
//  SettingsView.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 6/1/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject private var context: AppContext
    
    var body: some View {
        Form {
            Section {
                Button("Test push notifications") {
                    LocalNotification(subtitle: "Test", body: "This is a test notification").schedule(1)
                }
            } footer: {
                Label(context.authorisedAPN ? "APN authorized" : "APN denied", systemImage: context.authorisedAPN ? "bell" : "bell.slash")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    presentation.wrappedValue.dismiss()
                }
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
