//
//  LandmarkViewModel.swift
//  RunOnTheGo
//
//  Created by Cristian Gonzalez on 1/20/25.
//

import SwiftUI

class LandmarkViewModel: ObservableObject {
    @Published var landmarks: [Landmark] = [
        Landmark(name: "Eiffel Tower", description: "An iconic symbol of Paris.", isDone: false),
        Landmark(name: "Statue of Liberty", description: "A gift from France to the USA.", isDone: false),
        Landmark(name: "Great Wall of China", description: "A historic wall stretching across China.", isDone: false)
    ]

    func markAsDone(index: Int, with image: UIImage) {
        landmarks[index].isDone = true
        landmarks[index].image = image
    }

    func addLandmark(name: String, description: String) {
        guard !name.isEmpty else { return }
        let newLandmark = Landmark(name: name, description: description, isDone: false)
        landmarks.append(newLandmark)
    }

    func removeLandmark(at offsets: IndexSet) {
        landmarks.remove(atOffsets: offsets)
    }
}
