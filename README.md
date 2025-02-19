# Capstone: PAKKUN
As a pet owner like myself, I struggle keeping track of my pet's information like food log, weight log, etc. This app will help other pet owners like myself who needs their pet's information right way instead of searching everywhere for them or maybe you just don't remember on the spot. PAKKUN is the app that will store your pet's important information, think of it like a mini pocket notepad right off the tip of your fingers and just one click away. 

<img src="https://github.com/user-attachments/assets/2c4ff2bd-1ec8-4946-b569-18c9c9ebf944" width="200">
<img src="https://github.com/user-attachments/assets/dc0d69e1-18ec-4807-8535-f2047c0f8fce" width="200">
<img src="https://github.com/user-attachments/assets/154cde8f-cd21-4cdb-a0b2-d60419fb2bb3" width="200">
<img src="https://github.com/user-attachments/assets/2db166d7-5737-4d5a-b8be-2c0478739db6" width="200">

## Dependencies

PAKKUN relies on:

Google Firebase
- Firebase/Database
- Firebase/Auth
- Firebase/Storage

## Getting Started:

1. Create a Firebase project, In the Firebase console, click Add project, then follow the on-screen instructions to create a Firebase project.
2. Register your app with Firebase
   https://firebase.google.com/docs/ios/setup#register-app
3. Add a Firebase configuration file
   - Click Download GoogleService-Info.plist to obtain your Firebase Apple platforms config file (GoogleService-Info.plist).
   - Move your config file into the root of your Xcode project. If prompted, select to add the config file to all targets.

## Environment Set Up 

1. In Xcode, with your app project open, navigate to File > Swift Packages > Add Package Dependency.
2. When prompted, add the Firebase Apple platforms SDK repository:
   `https://github.com/firebase/firebase-ios-sdk`
3. Choose the Firestore library.
4. When finished, Xcode will automatically begin resolving and downloading your dependencies in the background.
5. Initialize Firebase in your app
   - Import the FirebaseCore module in your UIApplicationDelegate, as well as any other Firebase modules your app delegate uses.
   - Configure a FirebaseApp shared instance in your app delegate's application

## Troubleshooting 
### Clean and Rebuild the Project (MAC)
If the package is installed correctly but Xcode still can't find it:

1. Clean Build Folder:
   - In Xcode, press Shift + Command + K.
2. Close and Reopen Xcode.
3. Build the project again (Command + B).
  
