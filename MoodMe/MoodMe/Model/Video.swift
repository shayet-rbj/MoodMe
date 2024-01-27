//
//  Video.swift
//  MoodMe
//
//  Created by Shayet on 1/13/24.
//

import Foundation
import FirebaseFirestore

struct Video: Codable, Identifiable{
    @DocumentID var id: String?
    let urls: String
    let duration: Double
    let tag: String
}
