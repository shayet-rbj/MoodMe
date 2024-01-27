//
//  TabView.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScreenView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            RecordingView()
                .tabItem {
                    Label("Recording", systemImage: "recordingtape.circle")
                }
        }
    }
}

#Preview {
    TabView()
}
