//
//  MainView.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import SwiftUI

enum ActiveTab {
    case screen
    case recording
}

struct MainView: View {
    @State private var activeTab: ActiveTab = .screen

    var body: some View {
        VStack {
            switch activeTab {
            case .screen:
                ScreenView()
            case .recording:
                RecordingView()
            }
            
            Spacer()
            
            if activeTab == .screen {
                Button("Recording list") {
                    activeTab = .recording
                }
                .transition(.slide)
                .padding()
            } else if activeTab == .recording {
                Button("Camera") {
                    activeTab = .screen
                }
                .transition(.slide)
                .padding()
            }
        }
    }
}

#Preview {
    MainView()
}
