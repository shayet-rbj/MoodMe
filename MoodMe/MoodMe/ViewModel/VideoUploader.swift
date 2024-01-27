//
//  VideoUploader.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import Foundation
import Firebase
import FirebaseStorage


struct VideoUploader {
    static func uploadVideo(withData videoData: Data) async throws -> String? {
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child(filename)
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        
        do {
            let _ = try await ref.putDataAsync(videoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload video with error \(error.localizedDescription)")
            return nil
        }
        
        
    }
}
