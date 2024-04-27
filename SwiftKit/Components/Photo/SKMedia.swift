//
//  SKPhoto.swift
//  SwiftKit
//
//  Created by quanhua peng on 2024/3/18.
//

import Foundation
import UIKit
import Photos

public class SKMedia {
    
    public static func shareImage(with title:String, image: UIImage?, completion: @escaping (Bool) -> Void) {

        guard let imageToShare = image else {
            return
        }
        
        DispatchQueue.main.async {
            let activityItems: [Any] = [title, imageToShare]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityVC.completionWithItemsHandler = { (_, success, _, _) in
                completion(success)
            }
            BTDResponder.topViewController()?.present(activityVC, animated: true)
        }
    }
    
    public static func shareVideo(with title: String, videoURL: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let activityItems: [Any] = [videoURL]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityVC.completionWithItemsHandler = { (_, success, _, _) in
                completion(success)
            }
            BTDResponder.topViewController()?.present(activityVC, animated: true)
        }
    }
    
    public static func saveImageToPhotosAlbum(image: UIImage?, completion: @escaping (Bool) -> Void) {
        saveImageToPhotosAlbum(title: "", subTitle: "", image: image, completion: completion)
    }
    
    public static func saveImageToPhotosAlbum(title: String, subTitle: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let image = image else { return }
        let saveBlock: () -> Void = {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    saveBlock()
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        } else if authStatus != .authorized {
            DispatchQueue.main.async {
                SKAlert.showAppSettingAlert(title: title, message: subTitle) {
                    completion(false)
                } cancelAction: {
                    completion(false)
                }
            }
        } else {
            saveBlock()
        }
    }
    
    public static func saveVideoToPhotosAlbum(title: String, subTitle: String, videoURLStr: String?, completion: @escaping (Bool) -> Void) {
        guard let urlString = videoURLStr, let videoURL = URL(string: urlString) else {
            completion(false)
            return
        }
        
        let saveBlock: () -> Void = {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    saveBlock()
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        } else if authStatus != .authorized {
            DispatchQueue.main.async {
                SKAlert.showAppSettingAlert(title: title, message: subTitle) {
                    completion(false)
                } cancelAction: {
                    completion(false)
                }
            }
        } else {
            saveBlock()
        }
    }
    
    public static func checkCameraPermission(title: String, subTitle: String, completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        default:
            SKAlert.showAppSettingAlert(title: title, message: subTitle) {
                completion(false)
            } cancelAction: {
                completion(false)
            }
        }
    }
    
    public static func checkAudioPermission(title: String, subTitle: String, completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        default:
            SKAlert.showAppSettingAlert(title: title, message:subTitle) {
                completion(false)
            } cancelAction: {
                completion(false)
            }
        }
    }

    public static func mergeImages(baseImage: UIImage,
                                   overlayImage: UIImage) -> UIImage? {
        let scale = UIScreen.main.scale
        let baseWidth = baseImage.size.width / scale
        let baseHeight = baseImage.size.height / scale
        let frame = CGRect(x: 0, y: 0, width: baseWidth, height: baseHeight)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: baseWidth , height: baseHeight), false, 0)
        baseImage.draw(in: frame)
        overlayImage.draw(in: frame)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    public static func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        let asset = AVAsset(url: inputURL)
        
        // 检查是否可以使用给定的预设配置导出
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(false, NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot create export session."]))
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        // 删除旧文件
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: outputURL.path) {
            do {
                try fileManager.removeItem(at: outputURL)
            } catch {
                completion(false, error)
                return
            }
        }
        
        // 开始导出视频
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                case .completed:
                    completion(true, nil)
                default:
                    completion(false, exportSession.error)
                }
            }
        }
    }


}
