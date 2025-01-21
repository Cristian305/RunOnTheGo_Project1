//
//  LandmarkListView.swift
//  RunOnTheGo
//
//  Created by Cristian Gonzalez on 1/20/25.
//

import SwiftUI

struct LandmarkListView: View {
    @StateObject private var viewModel = LandmarkViewModel()
    @State private var newLandmarkName: String = "" // State for the name of the new landmark
    @State private var showAddLandmarkSheet = false // Toggles the sheet for adding landmarks

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.landmarks.indices, id: \.self) { index in
                    NavigationLink(destination: LandmarkDetailView(landmark: $viewModel.landmarks[index])) {
                        HStack {
                            Text(viewModel.landmarks[index].name)
                                .strikethrough(viewModel.landmarks[index].isDone, color: .gray)
                            Spacer()
                            if viewModel.landmarks[index].isDone {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.removeLandmark) // Swipe to delete landmarks
            }
            .navigationTitle("Landmarks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        // "+" Button to add a landmark
                        Button(action: {
                            showAddLandmarkSheet = true
                        }) {
                            Image(systemName: "plus")
                        }

                        // "-" Button for swipe-to-delete hint
                        EditButton() // Built-in button for enabling swipe-to-delete
                    }
                }
            }
            .sheet(isPresented: $showAddLandmarkSheet) {
                AddLandmarkView(viewModel: viewModel)
            }
        }
    }
}

struct AddLandmarkView: View {
    @ObservedObject var viewModel: LandmarkViewModel
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet
    @State private var newLandmarkName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter landmark name", text: $newLandmarkName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    viewModel.addLandmark(name: newLandmarkName)
                    presentationMode.wrappedValue.dismiss() // Close the sheet
                }) {
                    Text("Add Landmark")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(newLandmarkName.isEmpty) // Disable if input is empty
                .padding()

                Spacer()
            }
            .navigationTitle("Add Landmark")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
