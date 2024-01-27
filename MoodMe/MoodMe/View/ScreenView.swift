//
//  ScreenView.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import SwiftUI

struct ScreenView: View {
    @State private var isRecording = false
    @State private var navigateToRecordingList = false
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    var body: some View {
        ARViewContainer(isRecording: $isRecording, videoViewModel: videoViewModel)
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottom){
                ZStack{
                    // recording button
                    HStack{
                        Spacer()
                        Button{
                            isRecording.toggle()
                        } label: {
                            Image("Reels")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                                .opacity(isRecording ? 0 : 1)
                                .padding(12)
                                .frame(width: 60, height: 60)
                                .background{
                                    Circle()
                                        .stroke(isRecording ? .clear :.black)
                                }
                                .padding(6)
                                .background{
                                    Circle()
                                        .fill(isRecording ? .red : .white)
                                }
                        }
                        Spacer()
                    }
                    
                    // button to recording list
                    HStack{
                        Spacer()
                        Button(action: {
                            navigateToRecordingList = true
                        }) {
                            Image(systemName: "list.bullet.below.rectangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding()
                        }
                    }
                    
                }
                .background(NavigationLink(destination: RecordingView().environmentObject(videoViewModel), isActive: $navigateToRecordingList) { EmptyView() })
            }
    }
}


struct ARViewContainer: UIViewControllerRepresentable {
    @Binding var isRecording: Bool
    var videoViewModel: VideoViewModel
    
    func makeUIViewController(context: Context) -> ARViewController {
        let viewController = ARViewController()
        viewController.videoViewModel = videoViewModel // Pass the ViewModel
        return viewController
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        if isRecording {
            uiViewController.startRecording()
        } else {
            uiViewController.stopRecording()
        }
        
    }
}

#Preview {
    ScreenView()
}
