//
//  LandmarkViewModel.swift
//  RunOnTheGo
//
//  Created by Cristian Gonzalez on 1/20/25.
//

import SwiftUI

class LandmarkViewModel: ObservableObject {
    @Published var landmarks: [Landmark] = [
        Landmark(name: "Eiffel Tower", isDone: false),
        Landmark(name: "Statue of Liberty", isDone: false),
        Landmark(name: "Great Wall of China", isDone: false)
    ]

    func markAsDone(index: Int, with image: UIImage) {
        landmarks[index].isDone = true
        landmarks[index].image = image
    }

    func addLandmark(name: String) {
        guard !name.isEmpty else { return }
        let newLandmark = Landmark(name: name, isDone: false)
        landmarks.append(newLandmark)
    }

    func removeLandmark(at offsets: IndexSet) {
        landmarks.remove(atOffsets: offsets)
    }
}
