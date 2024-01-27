//
//  RecordingView.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct RecordingView: View {
    
    @EnvironmentObject var videoViewModel : VideoViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack (alignment: .bottom){
            ScrollView{
                Text("Recording List")
                    .font(.title)
                
                // display video and metadata
                ForEach(videoViewModel.videos){ video in
                    VideoPlayer(player: AVPlayer(url: URL(string: video.urls)!))
                        .frame(height: 250)
                        .cornerRadius(12)
                    // Display the tag and duration below the video
                    HStack{
                        Text("Tag: \(video.tag)")
                            .font(.headline)
                        Text("Duration: \(formatDuration(video.duration))")
                            .font(.subheadline)
                    }
                }
            }
            .refreshable {
                Task{
                    try await videoViewModel.fetchVideos()
                }
            }
            .padding()
        }
        
    }
    
    func formatDuration(_ duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(duration)) ?? ""
    }
}

#Preview {
    RecordingView()
}
