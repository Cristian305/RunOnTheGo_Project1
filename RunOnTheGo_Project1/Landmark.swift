//
//  Landmark.swift
//  RunOnTheGo
//
//  Created by Cristian Gonzalez on 1/20/25.
//

import UIKit

struct Landmark: Identifiable {
    let id = UUID()
    var name: String
    var isDone: Bool
    var image: UIImage?
}
