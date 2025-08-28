//
//  SnackDetailView.swift
//  ESSI
//
//  Created by Bob Witmer on 2025-08-26.
//

import SwiftUI
import SwiftData

struct SnackDetailView: View {
    
    enum ComfortLevel: Int, CaseIterable {
        case doesTheJob = 1
        case solid
        case cravingSatisfier
        case gourmet
        case emergencyComfort
        
        var label: String {
            switch self {
            case .doesTheJob: return "✅ Does the job"
            case .solid: return "👍 Solid"
            case .cravingSatisfier: return "😋 Craving met"
            case .gourmet: return "👨‍🍳 Gourmet"
            case .emergencyComfort: return "🚨 Emergency"
            }
        }
    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var snack: Snack
    @State private var name: String = ""
    @State private var onHand: Int = 0
    @State private var notes: String = ""
    @State private var selectedComfortLevel: Int = 1
    
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
            
            HStack {
                Text("Comfort Level: ")
                    .bold()
                Picker("", selection: $selectedComfortLevel) {
                    ForEach(ComfortLevel.allCases, id: \.self) { comfortLevel in
                        Text(comfortLevel.label)
                            .tag(comfortLevel.rawValue)
                    }
                }
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
            selectedComfortLevel = snack.comfortLevel
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
                    snack.comfortLevel = selectedComfortLevel
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
