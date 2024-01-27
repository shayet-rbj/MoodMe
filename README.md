# MoodMe - iOS ARKit Mustache Video App

## Demo Video
Watch a live demo of the app: [App Demo](https://youtu.be/v5zQu7ZcEGs).

## Overview
This iOS app, built in Swift, allows users to capture video and audio using their device's camera, add a mustache to their face in real-time using ARKit, and save these videos with metadata into an Firebase database. Users can choose from a variety of mustache styles and tag their recordings.

## Features
- **Video Capture:** Record video and audio using the device's camera.
- **ARKit Mustache Overlay:** Add a virtual mustache to the user's face in real-time.
- **Dynamic Mustache Styles:** Choose from a pre-embedded set of mustache styles.
- **Firebase Database:** Save session videos, duration, and user-defined tags into an Firebase database.
- **Recording Management:** Review recorded sessions with ease.


## Installation
Follow these steps to set up the project on your local machine:

1. **Clone or Download the Repository:**
   - Use Git to clone the repo or download the ZIP file directly from the repository page.

2. **Install CocoaPods (if not already installed):**
   - CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects. If you haven't installed CocoaPods yet, open your terminal and run:
     ```
     sudo gem install cocoapods
     ```

3. **Install Dependencies with CocoaPods:**
   - Navigate to your project directory in the terminal. This is where the `Podfile` is located.
   - Run the following command to install the required pods:
     ```
     pod install
     ```

4. **Open the Project in Xcode:**
   - Open the `.xcworkspace` file, not the `.xcodeproj` file, to ensure all the pod dependencies are correctly linked.

5. **Build and Run the App:**
   - Select a compatible iOS device.
   - Press the 'Run' button in Xcode to build and run the application on your selected device or simulator.


## Usage

### Video Screen
- **Record:** Start recording video and audio.
- **Mustaches List:** Tap mustache to switch to different mustache styles.
- **Stop Button:** Stop recording and save the session.
- **Tagging Popup:** After stopping, enter a tag for the recording before saving.

### Recording List Screen
- **View List:** Display a list of recorded videos with previews.
- **Metadata:** Shows video duration and user-defined tag.

## Architecture
- **MVVM Pattern:** The app is structured using the Model-View-ViewModel (MVVM) pattern for clean and maintainable code.
- **Firebase:** Firebase is used for efficient data management and retrieval.
- **ARKit for Mustache Overlay:** Utilizes ARKit for real-time facial recognition and overlay.



