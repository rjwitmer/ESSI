//
//  LaunchView.swift
//  ESSI
//
//  Created by Bob Witmer on 2025-08-26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData

struct LaunchView: View {
    @Query private var snacks: [Snack]
    @Environment(\.modelContext) private var modelContext   // For holding temporary data before saving
    @State private var sheetIsPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(snacks) { snack in
                    NavigationLink {
                        SnackDetailView(snack: snack)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(snack.name)
                                .font(.title)
                                .lineLimit(1)
                            HStack {
                                Text("Qty: \(snack.onHand)")
                                Text(snack.notes)
                                    .italic()
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                            .font(.body)
                        }
                    }
                }
            }
            .listStyle(.automatic)
            .navigationTitle("Snacks on Hand:")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .fullScreenCover(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SnackDetailView(snack: Snack())
                }
            }
        }
        
    }
}

#Preview(windowStyle: .automatic) {
    LaunchView()
        .modelContainer(Snack.preview)
}
