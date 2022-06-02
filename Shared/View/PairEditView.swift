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
    
    @ObservedObject private var pair: LensPair
    
    public init(_ pair: LensPair) {
        _pair = ObservedObject(initialValue: pair)
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    let material = Binding<Lens.Material> { pair.material } set: {
                        pair.left?.material = $0
                        pair.right?.material = $0
                    }
                    Text("Material")
                    Spacer()
                    Picker(selection: material) {
                        Text("Soft").tag(Lens.Material.soft)
                        Text("Hard (RGP)").tag(Lens.Material.hard)
                    } label: {}
                    .pickerStyle(.menu)
                }
                HStack {
                    let wearSchedule = Binding<LensPair.WearSchedule> { pair.wearSchedule } set: { schedule in
                        pair.wearSchedule = schedule
                    }
                    Text("Wear schedule")
                    Spacer()
                    Picker(selection: wearSchedule.animation()) {
                        Text("Daily").tag(LensPair.WearSchedule.daily)
                        Text("Extended").tag(LensPair.WearSchedule.extended)
                    } label: {}
                    .pickerStyle(.menu)
                }
            } header: {
                Text("Details")
            }
            Section {
                DatePicker("Start", selection: $pair.startAt, displayedComponents: .date)
                DatePicker("End", selection: $pair.endAt, displayedComponents: .date)
                    .disabled(pair.wearSchedule == .daily)
            } header: {
                Text("Wear / replacement schedule")
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
            TextField("Ex: -3.5", text: Binding<String> { "\(lens.power)" } set: { lens.power = Float($0) ?? 0 })
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
        }
        HStack {
            Text("Diameter")
            Spacer()
            TextField("Ex: 8.6", text: Binding<String> { "\(lens.diameter)" } set: { lens.diameter = Float($0) ?? 0 })
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
        }
        HStack {
            Text("Curvature")
            Spacer()
            TextField("Ex: 14.2", text: Binding<String> { "\(lens.curvature)" } set: { lens.curvature = Float($0) ?? 0 })
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
