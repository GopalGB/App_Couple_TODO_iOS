//
//  ProfileSetupView.swift
//  TogetherList
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var name = ""
    @State private var showingImagePicker = false
    @State private var profileImage: UIImage?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Set Up Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 20) {
                // Profile Image
                Button(action: { showingImagePicker = true }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 120, height: 120)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .font(.title2)
                                    Text("Add Photo")
                                        .font(.caption)
                                }
                                .foregroundColor(.secondary)
                            )
                    }
                }
                
                // Name Input
                TextField("Your Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
            }
            
            VStack(spacing: 15) {
                Text("Your Connection Code")
                    .font(.headline)
                
                Text(userSettings.connectionCode)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Text("Share this code with your partner to connect")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button("Continue") {
                userSettings.updateProfile(name: name, imageData: profileImage?.jpegData(compressionQuality: 0.8))
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(name.isEmpty ? Color.gray : Color.pink)
            .cornerRadius(12)
            .disabled(name.isEmpty)
        }
        .padding()
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}