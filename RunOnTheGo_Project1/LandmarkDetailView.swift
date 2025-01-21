//
//  LandmarkDetailView.swift
//  RunOnTheGo
//
//  Created by Cristian Gonzalez on 1/20/25.
//

import SwiftUI
import PhotosUI
import MapKit

struct LandmarkDetailView: View {
    @Binding var landmark: Landmark
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?  
    @State private var imageLocation: CLLocationCoordinate2D? // Location of the image
    @State private var annotations: [IdentifiablePointAnnotation] = [] // Updated to use Identifiable struct
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default center
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)       // Default zoom level
    )

    var body: some View {
        VStack {
            Text(landmark.name)
                .font(.largeTitle)

            // Map View
            Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    VStack {
                        // Display the uploaded image above the pin
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                .shadow(radius: 5)
                        }

                        // Display the pin below the image
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 300)
            .cornerRadius(12)
            .padding(.bottom)

            // Display Selected Image
            if let image = landmark.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("No image uploaded yet")
                    .foregroundColor(.gray)
            }

            // Action Buttons
            HStack {
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Upload Photo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    showCameraPicker = true
                }) {
                    Text("Take Photo")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newValue in
            if let image = newValue {
                handleImageSelection(image: image)
            }
        }
    }

    private func handleImageSelection(image: UIImage) {
        // Simulating location metadata extraction for simplicity
        let simulatedLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Example location

        // Update the landmark's image and location
        landmark.image = image
        landmark.isDone = true
        imageLocation = simulatedLocation

        // Add an annotation to the map view
        if let location = imageLocation {
            let annotation = IdentifiablePointAnnotation(
                coordinate: location,
                title: "Image Location"
            )
            annotations = [annotation] // Replace with new annotation
            region.center = location   // Update map region to center on the image location
        }
    }
}

// MARK: - Custom Identifiable Annotation
struct IdentifiablePointAnnotation: Identifiable {
    let id = UUID() // Unique ID for each annotation
    var coordinate: CLLocationCoordinate2D
    var title: String?
}

// MARK: - Camera Picker
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()

        #if targetEnvironment(simulator)
        picker.sourceType = .photoLibrary // Use photo library in the simulator
        #else
        picker.sourceType = .camera // Use the camera on physical devices
        #endif

        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
