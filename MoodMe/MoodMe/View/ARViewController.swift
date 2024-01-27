//
//  ARViewController.swift
//  swiftuiadding
//
//  Created by Shayet on 1/13/24.
//  reference: https://github.com/soonin/IOS-Swift-ARkitFaceTrackingNose01

import UIKit
import ARKit
import SceneKit
import AVFoundation
import ARCapture
import Photos

class ARViewController: UIViewController, ARSCNViewDelegate {
    var sceneView: ARSCNView!
    let mustacheOptions = ["Mustache01", "Mustache02", "Mustache03", "Mustache04", "Mustache05", "Mustache06", "Mustache07"]
    let features = ["mustache"]
    var featureIndices = [[293, 3]]
    var capture: ARCapture?
    var videoViewModel: VideoViewModel?
    var videoTag: String?
    var audioCaptureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)

        // Configure the ARSCNView
        sceneView.delegate = self
        sceneView.showsStatistics = false // Optional: for showing performance statistics
        
        // Set up the AR session
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)

        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesture)
        
        // Setup ARCapture
        capture = ARCapture(view: sceneView)
    }
    
    func startRecording() {
        print("start recording")
        capture?.start()
    }

    func stopRecording() {
        capture?.stop({ status in
            // Handle the completion of the recording
            print("Video exported: \(status)")
            
            DispatchQueue.main.async {
                self.presentTagEntryPopup()
            }
        })
        
    }
    
    // Function to present the tag entry popup
    func presentTagEntryPopup() {
        let alertController = UIAlertController(title: "Tag Your Video", message: "Enter a tag for your video", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Tag"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned alertController, weak self] _ in
            guard let self = self, let textField = alertController.textFields?.first, let tag = textField.text else { return }
            self.videoTag = tag
            // After getting the tag, fetch the latest video and upload it
            self.fetchLatestVideo { url in
                guard let videoURL = url else {
                    print("Failed to fetch the video URL")
                    return
                }

                // Convert the video to Data for upload
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    // Calculate video duration
                    let asset = AVURLAsset(url: videoURL)
                    let duration = asset.duration
                    let durationInSeconds = CMTimeGetSeconds(duration)
                    
                    // Use the videoViewModel to upload the video data, duration, and tag to Firestore
                    Task {
                        try await self.videoViewModel?.uploadVideo(videoData, duration: durationInSeconds, tag: self.videoTag ?? "")
                    }
                } catch {
                    print("Error converting video to Data: \(error)")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // fetch latest video and upload to firebase
    func fetchLatestVideo(completion: @escaping (URL?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        guard let lastAsset = fetchResult.firstObject else {
            completion(nil)
            return
        }

        let options = PHVideoRequestOptions()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: lastAsset, options: options) { (asset, audioMix, info) in
            if let urlAsset = asset as? AVURLAsset {
                let localVideoUrl = urlAsset.url
                completion(localVideoUrl)
            } else {
                completion(nil)
            }
        }
    }
    
    // handle tap action
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let results = sceneView.hitTest(location, options: nil)
        if let result = results.first,
           let node = result.node as? FaceNode {
            node.next()
        }
    }

    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        for (feature, indices) in zip(features, featureIndices) {
            let child = node.childNode(withName: feature, recursively: false) as? FaceNode
            let vertices = indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }

    // ARSCNViewDelegate methods
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = MTLCreateSystemDefaultDevice(),
              let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.transparency = 0.0
        
        let mustacheNode = FaceNode(with: mustacheOptions)
        mustacheNode.name = "mustache"
        node.addChildNode(mustacheNode)
        
        updateFeatures(for: node, using: faceAnchor)
        
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}


