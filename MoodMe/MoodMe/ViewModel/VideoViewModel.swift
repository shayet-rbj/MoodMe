//
//  VideoViewModel.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import Foundation
import PhotosUI
import SwiftUI
import AVFoundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class VideoViewModel: ObservableObject {
    @Published var videos = [Video]()
    
    init(){
        Task {
            try await fetchVideos()
        }
    }
    
    // upload video to firebase
    func uploadVideo(_ videoData: Data, duration: Double, tag: String) async throws {
        guard let videoUrl = try await VideoUploader.uploadVideo(withData: videoData) else {return}
        
        
        let video = Video(urls: videoUrl, duration: duration, tag: tag)
        
        do {
           let encodedVideo = try Firestore.Encoder().encode(video)
            try await Firestore.firestore().collection("vidoes").document().setData(encodedVideo)
        } catch let error {
           print("DEBUG: Failed to upload video to firestorage with error \(error.localizedDescription)")
        }
        
        print("DEBUG: Finished video upload")
    }
    
    @MainActor
    func fetchVideos() async throws{
        let snapshot = try await Firestore.firestore().collection("vidoes").getDocuments()
        self.videos = snapshot.documents.compactMap({try? $0.data(as: Video.self)})
    }
}
