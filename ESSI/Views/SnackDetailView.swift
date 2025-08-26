//
//  SnackDetailView.swift
//  ESSI
//
//  Created by Bob Witmer on 2025-08-26.
//

import SwiftUI
import SwiftData

struct SnackDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var snack: Snack
    @State private var name: String = ""
    @State private var onHand: Int = 0
    @State private var notes: String = ""
    @State private var comfortLevel: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("snack name", text: $name)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
            HStack {
                Text("Qty: ")
                    .bold()
                    .padding(.leading)
                Stepper("\(onHand)", value: $onHand, in: 0...Int.max)
                    .padding(.trailing)
            }
            .padding(.bottom)
            Text("Notes:")
            TextField("notes", text: $notes, axis: .vertical)
                .bold()
                .textFieldStyle(.roundedBorder)
                
            Spacer()
        }
        .padding()
        .listStyle(.automatic)
        .onAppear() {
            name = snack.name
            onHand = snack.onHand
            notes = snack.notes
            comfortLevel = snack.comfortLevel
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // Move data from local vars to the toDo object
                    snack.name = name
                    snack.onHand = onHand
                    snack.notes = notes
                    snack.comfortLevel = comfortLevel
                    // Save the data to SwiftData modelContext
                    modelContext.insert(snack)  // Will add new or update existing
                    // Save the data to SwiftData data store
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Failed to save data to the data store!")
                        return
                    }
                    // Return to parent view
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SnackDetailView(snack: Snack(name: "Lil Swifties", onHand: 3, notes: "Homemade cookies baked by Prof. G.", comfortLevel: 5))
            .modelContainer(for: Snack.self, inMemory: true)
    }
}
