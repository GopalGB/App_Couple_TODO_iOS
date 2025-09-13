//
//  CompleteActivityView.swift
//  TogetherList
//

import SwiftUI

struct CompleteActivityView: View {
    let activity: Activity
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var notes = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Activity Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text(activity.title ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let description = activity.activityDescription {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Notes Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Notes (Optional)")
                            .font(.headline)
                        
                        TextField("How was it? Any special moments?", text: $notes, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    // Photos Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Add Photos")
                            .font(.headline)
                        
                        if selectedImages.isEmpty {
                            VStack(spacing: 15) {
                                HStack(spacing: 15) {
                                    Button(action: { showingCamera = true }) {
                                        VStack {
                                            Image(systemName: "camera.fill")
                                                .font(.title2)
                                            Text("Camera")
                                                .font(.caption)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                    
                                    Button(action: { showingImagePicker = true }) {
                                        VStack {
                                            Image(systemName: "photo.on.rectangle")
                                                .font(.title2)
                                            Text("Gallery")
                                                .font(.caption)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        Button(action: { selectedImages.remove(at: index) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .padding(4)
                                    }
                                }
                                
                                // Add more button
                                Button(action: { showingImagePicker = true }) {
                                    VStack {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                        Text("Add More")
                                            .font(.caption)
                                    }
                                    .frame(height: 100)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Complete Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Complete") {
                        completeActivity()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: .constant(nil)) { image in
                if let image = image {
                    selectedImages.append(image)
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(image: .constant(nil)) { image in
                if let image = image {
                    selectedImages.append(image)
                }
            }
        }
    }
    
    private func completeActivity() {
        dataController.completeActivity(
            activity,
            with: selectedImages,
            notes: notes.isEmpty ? nil : notes
        )
        presentationMode.wrappedValue.dismiss()
    }
}

// Enhanced ImagePicker for multiple selection
extension ImagePicker {
    init(image: Binding<UIImage?>, onImagePicked: @escaping (UIImage?) -> Void) {
        self._image = image
        self.onImagePicked = onImagePicked
    }
    
    private var onImagePicked: ((UIImage?) -> Void)?
}

// Enhanced CameraView
extension CameraView {
    init(image: Binding<UIImage?>, onImageCaptured: @escaping (UIImage?) -> Void) {
        self._image = image
        self.onImageCaptured = onImageCaptured
    }
    
    private var onImageCaptured: ((UIImage?) -> Void)?
}