//
//  PhotoManager.swift
//  TogetherList
//

import SwiftUI
import Photos
import CoreData

class PhotoManager: ObservableObject {
    static let shared = PhotoManager()
    
    @Published var hasPhotoPermission = false
    
    private init() {
        checkPhotoPermission()
    }
    
    func checkPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            hasPhotoPermission = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.hasPhotoPermission = (status == .authorized || status == .limited)
                }
            }
        default:
            hasPhotoPermission = false
        }
    }
    
    func savePhoto(_ image: UIImage, for activity: Activity) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let context = DataController.shared.container.viewContext
        let photo = Photo(context: context)
        photo.id = UUID()
        photo.imageData = imageData
        photo.takenDate = Date()
        photo.activity = activity
        photo.addedBy = UserSettings.shared.userID
        
        // Save to photo library
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
        }) { success, error in
            if let error = error {
                print("Error saving to photo library: \(error)")
            }
        }
        
        DataController.shared.save()
    }
    
    func compressImage(_ image: UIImage, maxSize: CGFloat = 1024) -> UIImage {
        let size = image.size
        let widthRatio = maxSize / size.width
        let heightRatio = maxSize / size.height
        let ratio = min(widthRatio, heightRatio)
        
        if ratio >= 1.0 {
            return image
        }
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return compressedImage ?? image
    }
}