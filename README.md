# Driver App (UDrive) - Simple Driver App

A application for drivers to manage their work with camera, GPS, and biometric features, developed using Clean Architecture, MVVM pattern, and Riverpod state management.

## 📸 Screenshots & 🔗 Download Link

<div style="display: flex; flex-wrap: wrap; gap: 8px;">
  <img src="screenshots/gate.png" width="175">
  <img src="screenshots/home_pending_light.png" width="175">
  <img src="screenshots/home_pending_dark.png" width="175">
  <img src="screenshots/home_ongoing.png" width="175">
  <img src="screenshots/home_completed.png" width="175">
  <img src="screenshots/job_detail.png" width="175">
  <img src="screenshots/stop_action.png" width="175">
  <img src="screenshots/settings.png" width="175">
</div>

- Downlaod link: https://drive.google.com/file/d/1MMuxF5wavCBCo0ZVg6bx9AbIDe6Pz1Et/view?usp=sharing

## ✨ Features

- Job management with status: Pending, Ongoing, Completed
- Multiple stops per job (Pickup & Dropoff)
- Take photo of location proof using camera
- Automatic GPS coordinate confirmation
- Biometric using Fingerprint
- Light and dark themes
- Local data storage with SharedPreferences
- Clean and user-friendly UI
- State management using Riverpod

## 🏗️ Architecture

Using **Clean Architecture** with 3 layers:

- **Domain Layer**: Entities, Repositories, UseCases
- **Data Layer**: Models, DataSources (Local), Repository Implementations
- **Presentation Layer**: Providers (MVVM), Screens

## 📦 Tech Stack

- **State Management**: Riverpod
- **Architecture**: Clean Architecture + MVVM
- **Local Authentication**: local_auth
- **Local Storage**: shared_preferences
- **Permission**: permission_handler
- **Location**: geolocator
- **Path**: path_provider

## 🚀 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run

```bash
flutter run
```

## 🎨 Theme

The app supports light and dark themes.

## 📝 Validation on the Application

**Job Management**
- Cannot start a job when another job is ongoing
- Cannot complete a stop if not take a photo of location and confirm GPS

**Stop Validation**
- Must take a photo of location
- Must confirm GPS
- Both steps must be completed in order to press “Complete Stop”

**Auto Complete Job**
- Job automatically completes when all stops are finished

## 🔧 Dependencies

```yaml
dependencies:  
  dartz: ^0.10.1                # Functional programming
  equatable: ^2.0.7             # Value comparison
  geocoding: ^4.0.0             # Geocoding
  geolocator: ^14.0.2           # Location
  get: ^4.7.3                   # State management
  heroicons: ^0.11.0            # Icons
  http: ^1.6.0                  # API calls
  intl: ^0.20.2                 # Formatter
  shared_preferences: ^2.5.3    # Local storage
```

## 📱 How to Use the App

### 1. Viewing the Job List

- Open the app, you will see 3 tabs: Pending, Ongoing, and Completed
- Tap on a job to view its details

### 2. Starting a Job

- Select a job from the Pending tab
- Tap the “Start Job” button
- Confirm to start the job
- The job status will change to Ongoing
- The job will move to the Ongoing tab

### 3. Completing a Stop

For each stop, you must complete 2 steps:

#### Step 1: Take a Photo
- Tap the stop in order
- Tap the “Take Photo” section
- Take a photo and a preview of the photo will appear
- Select “Use Photo” or “Retake”

#### Step 2: Confirm GPS
- Tap the “Confirm Location Coordinates” section
- GPS will automatically obtain the coordinates

#### Complete Stop
- Tap the “Complete Stop” button
- The stop status will change to Completed

### 4. Completing the Job

- After all stops are completed
- The job will automatically change its status to Completed
- The job will move to the Completed tab