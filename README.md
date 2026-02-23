# Notes App 📒

A feature-rich note-taking application built with Flutter, featuring user authentication, rich text editing, cloud synchronization, and real-time updates.

---

## 📋 Project Overview

This is a complete note-taking application developed as a team project for a second-semester course. The app allows users to create, edit, organize, and sync notes across devices with proper user authentication and cloud storage.

---

## ✨ Key Features

### 🔐 Authentication
- Email/Password registration with email verification
- Google Sign-In integration
- Password recovery functionality
- Secure logout

### 📝 Note Management
- Create, read, update, and delete notes
- Rich text editing (bold, italic, underline, etc.)
- Tag system for organizing notes
- Search by title, content, or tags
- Grid/List view toggle
- Sort by creation or modification date
- Read-only mode for safe viewing

### ☁️ Cloud Integration
- Real-time synchronization with Firebase Firestore
- Per-user data isolation (each user sees only their notes)
- Automatic data backup
- Offline support

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Flutter | UI framework |
| Dart | Programming language |
| Firebase Authentication | User management |
| Cloud Firestore | Database |
| Provider | State management |
| Flutter Quill | Rich text editor |

---
🚀 How to Run the Project

Prerequisites Checklist
Before starting, make sure you have:

- Flutter SDK (version 3.10.7 or higher)

- Android Studio OR VS Code with Flutter extensions

- Git (to clone the repository)

- Firebase account (free tier works)

Step 1: Install Flutter
If you don't have Flutter installed:

1. Go to Flutter Installation Page

2. Download the Flutter SDK for your operating system (Windows/macOS/Linux)

3. Extract the downloaded file

4. Add Flutter to your system PATH

5. Verify installation:

bash
flutter doctor

Step 2: Get the Project Code

Option A: Clone with Git

bash
git clone <repository-url>

d noteapp


Option B: Download ZIP

1. Download the project ZIP file

2. Extract it to a folder

3. Open terminal/command prompt in that folder

Step 3: Install Dependencies

Run this command in the project folder:

flutter pub get

Step 4: Firebase Setup

Option A: Use Provided Firebase Configuration (Recommended)

1. Get the Firebase configuration files from the project team:

- google-services.json for Android

- GoogleService-Info.plist for iOS

2. Place them in the correct locations:

- Android: android/app/google-services.json

- iOS: ios/Runner/GoogleService-Info.plist


Option B: Create Your Own Firebase Project

1. Go to Firebase Console

2. Click "Add project" and follow steps

3. Register your app:

- Android: Package name com.example.noteapp

- iOS: Bundle ID com.example.noteapp

- Web: Add http://localhost to authorized domains

4. Download configuration files and place them as shown above

5. Enable Authentication:

- Go to Authentication → Sign-in method

- Enable Email/Password

- Enable Google Sign-In

6. Create Firestore Database:

- Go to Firestore Database → Create database

- Choose Start in test mode

- Select a location (choose closest to you)

Step 5: Run the App
For Android: flutter run

(Make sure you have an Android emulator running or a physical device connected.)

📱 Testing the App

Quick Test Flow

1. Register a new account

2. Check your email and verify your account

3. Login with your credentials

4. Create a note by tapping the + button

5. Add tags to organize your note

6. Save and see it in the list

7. Try search and filter options

8. Logout and test with another user

🔑 Key Implementation Details

State Management


- Provider pattern with multiple ChangeNotifiers

- Real-time Firestore streams for live updates


Authentication Flow
1. User registers/logs in

2. Email verification required

3. Upon verification, access to notes

4. Logout clears session


Data Structure

users/{userId}/notes/{noteId}
- title: String?
- content: String?
- contentJson: String
- dateCreated: int
- dateModified: int
- tags: List<String>


🐛 Known Issues & Fixes

Issue

- Notes appearing across users
- Back button not saving
- Google Sign-In crash

Fix
- Added ValueKey to MainPage
- Fixed provider access in initState
- Updated to correct API


📚 References

Flutter Documentation

- Flutter Official Docs

- Flutter Installation Guide

Firebase Documentation

- FlutterFire Overview
- Firebase Authentication
- Cloud Firestore


Link use

Links 🔗 used in the video
https://pub.dev/packages/font_awesome...
https://fonts.google.com/specimen/Pop...
https://fonts.google.com/specimen/Fre...
https://pub.dev/packages/flutter_quill
https://pub.dev/packages/provider
https://pub.dev/packages/intl
https://api.flutter.dev/flutter/intl/...
https://firebase.google.com/docs/flut...
https://firebase.google.com/docs/auth...
https://docs.gradle.org/current/userg...

Icons used in the thumbnail
https://iconscout.com/icons/firebase & https://iconscout.com/icons/flutter by https://iconscout.com/contributors/ic...


My github
https://github.com/Senghor11/noteapp.git

Figma 
https://www.figma.com/design/VOkc7JKxyKBRA0YkiP0XG9/Untitled?node-id=0-1&t=NFRWQtrWo9sRYOHq-1

### 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.8
  font_awesome_flutter: ^10.12.0
  flutter_quill: ^11.5.0
  provider: ^6.1.5+1
  intl: ^0.20.2
  firebase_core: ^4.4.0
  firebase_auth: ^6.1.4
  cloud_firestore: ^5.5.0
  google_sign_in: ^7.2.0 

