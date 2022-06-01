//
//  PairEditView.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 5/31/22.
//

import SwiftUI

struct PairEditView: View {
    
    @Environment(\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var pair: Pair
    
    public init(_ pair: Pair) {
        _pair = ObservedObject(initialValue: pair)
    }
    
    var body: some View {
        Form {
            Section {
                DatePicker("Start", selection: $pair.startAt, displayedComponents: .date)
                DatePicker("End", selection: $pair.endAt, displayedComponents: .date)
            } header: {
                Text("Pair")
            } footer: {
                Text("Replacement needed \(pair.endAt, format: .relative(presentation: .named))")
            }
            if let left = pair.left {
                Section {
                    lensView(left)
                } header: {
                    Text("Left contact lens")
                }
            }
            if let right = pair.right {
                Section {
                    lensView(right)
                } header: {
                    Text("Right contact lens")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: viewContext.rollback)
        .onChange(of: pair.startAt) {
            pair.endAt = $0.addingTimeInterval(30 * 24 * 60 * 60)
        }
        .toolbar {
            toolbar
        }
    }
    
    @ViewBuilder
    private func lensView(_ lens: Lens) -> some View {
        HStack {
            Text("Power")
            Spacer()
            TextField("For example: -3.5", text: Binding<String> { "\(lens.power)" } set: { lens.power = Float($0) ?? 0 })
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
        }
        HStack {
            Text("Diameter")
            Spacer()
            TextField("For example: 8.6", text: Binding<String> { "\(lens.diameter)" } set: { lens.diameter = Float($0) ?? 0 })
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
        }
        HStack {
            Text("Curvature")
            Spacer()
            TextField("For example: 14.2", text: Binding<String> { "\(lens.curvature)" } set: { lens.curvature = Float($0) ?? 0 })
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
        }
        Toggle(isOn: Binding<Bool> { lens.isToric } set: { lens.isToric = $0 }) {
            Text("Is toric")
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Close") {
                presentation.wrappedValue.dismiss()
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                do {
                    try viewContext.save()
                    presentation.wrappedValue.dismiss()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}


struct PairEditView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
            NavigationView {
                PairEditView(.preview)
            }
        }
    }
}
