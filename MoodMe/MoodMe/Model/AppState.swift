//
//  AppState.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import Foundation

enum ActiveTab {
    case screen
    case recording
}


class AppState: ObservableObject {
    @Published var activeTab: ActiveTab = .screen
}
