//
//  MediaPicker.swift
//
//  Created by Rohit Singh Dhakad on 07/04/23.
//


import Foundation
import UIKit
import AVFoundation
import Photos

class MediaPicker: NSObject {
    
    static let shared = MediaPicker()
    private override init() {}
    
    private var imageCompletion: ((UIImage?, [String: Any]?) -> Void)?
    private var videoCompletion: ((URL?, UIImage?, [String: Any]?) -> Void)?
    
    // Pick Media (Image or Photo)
    func pickMedia(from viewController: UIViewController, completion: @escaping (UIImage?, [String: Any]?) -> Void) {
        self.imageCompletion = completion
        
        let alertController = UIAlertController(title: "Select Media", message: nil, preferredStyle: .actionSheet)
        
        // Camera action for taking a photo
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (_) in
            self.checkCameraPermission {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.mediaTypes = ["public.image"]
                    picker.delegate = self
                    viewController.present(picker, animated: true, completion: nil)
                }
            }
        }
        
        // Gallery action for selecting a photo
        let galleryAction = UIAlertAction(title: "Choose from library", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.image"]
            viewController.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Pick Video (Record or Select from gallery)
    func pickVideo(from viewController: UIViewController, completion: @escaping (URL?, UIImage?, [String: Any]?) -> Void) {
        self.videoCompletion = completion
        
        let alertController = UIAlertController(title: "Select Video", message: nil, preferredStyle: .actionSheet)
        
        // Record Video action
        let recordVideoAction = UIAlertAction(title: "Record video", style: .default) { (_) in
            self.checkCameraPermission {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.mediaTypes = ["public.movie"]
                    picker.delegate = self
                    picker.videoQuality = .typeHigh
                    viewController.present(picker, animated: true, completion: nil)
                }
            }
        }
        
        // Select Video from library
        let galleryVideoAction = UIAlertAction(title: "Choose video from library", style: .default) { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            viewController.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(recordVideoAction)
        alertController.addAction(galleryVideoAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    private func checkCameraPermission(completion: @escaping () -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    completion()
                }
            }
        case .denied, .restricted:
            let alertController = UIAlertController(title: "Camera permission required", message: "Please grant permission to access the camera", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            guard let topViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.topViewController() else {
                fatalError("Unable to get top view controller.")
            }
            topViewController.present(alertController, animated: true, completion: nil)
        @unknown default:
            break
        }
    }
    
    // Generate Thumbnail from Video URL
    private func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2) // Generate at 1/2 second for better quality
        
        DispatchQueue.global().async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension MediaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Handling media (images or videos) after selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let mediaType = info[.mediaType] as? String, mediaType == "public.movie" {
            // If a video is picked or recorded
            if let videoURL = info[.mediaURL] as? URL {
                generateThumbnail(from: videoURL) { thumbnail in
                    self.videoCompletion?(videoURL, thumbnail, ["mediaType": "video", "videoURL": videoURL.absoluteString])
                }
            } else {
                videoCompletion?(nil, nil, nil)
            }
        } else if let image = info[.originalImage] as? UIImage {
            // If an image is picked
            imageCompletion?(image, ["mediaType": "image"])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageCompletion?(nil, nil)
        videoCompletion?(nil, nil, nil)
    }
}

extension UIViewController {
    func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topViewController: UIViewController = rootViewController
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
}


//import Foundation
//import UIKit
//import AVFoundation
//import Photos
//
//class MediaPicker: NSObject {
//    
//    static let shared = MediaPicker()
//    private override init() {}
//    
//    private var completion: ((UIImage?) -> Void)?
//    
//    func pickMedia(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
//        self.completion = completion
//        
//        let alertController = UIAlertController(title: "Select media", message: nil, preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (_) in
//            self.checkCameraPermission {
//                DispatchQueue.main.async {
//                    let picker = UIImagePickerController()
//                    picker.sourceType = .camera
//                    picker.delegate = self
//                    viewController.present(picker, animated: true, completion: nil)
//                }
//            }
//        }
//        let galleryAction = UIAlertAction(title: "Choose from library", style: .default) { (_) in
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            viewController.present(picker, animated: true, completion: nil)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        alertController.addAction(cameraAction)
//        alertController.addAction(galleryAction)
//        alertController.addAction(cancelAction)
//        
//        viewController.present(alertController, animated: true, completion: nil)
//    }
//    
//    private func checkCameraPermission(completion: @escaping () -> Void) {
//        let status = AVCaptureDevice.authorizationStatus(for: .video)
//        switch status {
//        case .authorized:
//            completion()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { (granted) in
//                if granted {
//                    completion()
//                }
//            }
//        case .denied, .restricted:
//            let alertController = UIAlertController(title: "Camera permission required", message: "Please grant permission to access the camera", preferredStyle: .alert)
//            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
//                if let url = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            
//            alertController.addAction(settingsAction)
//            alertController.addAction(cancelAction)
//            
//            guard let topViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.topViewController() else {
//                fatalError("Unable to get top view controller.")
//            }
//            topViewController.present(alertController, animated: true, completion: nil)
//        @unknown default:
//            break
//        }
//    }
//}
//
//extension MediaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        guard let image = info[.originalImage] as? UIImage else {
//            completion?(nil)
//            return
//        }
//        
//        completion?(image)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//        completion?(nil)
//    }
//}
//
//extension UIViewController {
//    func topViewController() -> UIViewController? {
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
//            let rootViewController = window.rootViewController else {
//            return nil
//        }
//        
//        var topViewController: UIViewController = rootViewController
//        while let presentedViewController = topViewController.presentedViewController {
//            topViewController = presentedViewController
//        }
//        
//        return topViewController
//    }
//}
