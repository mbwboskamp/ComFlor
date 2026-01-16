# DriverSense App - Platform Setup Guide

This guide covers the complete setup for both Android and iOS platforms.

## Prerequisites

1. **Flutter SDK**: Version 3.x or higher
2. **Android Studio**: Latest version with Android SDK
3. **Xcode**: Version 15+ (for iOS development on macOS)
4. **CocoaPods**: `sudo gem install cocoapods`

## Initial Setup

```bash
# Clone the repository
git clone https://github.com/your-org/driversense_app.git
cd driversense_app

# Install Flutter dependencies
flutter pub get

# Generate code (Drift database, injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n
```

---

## Android Setup

### 1. SDK Requirements

- **Minimum SDK**: 23 (Android 6.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34

### 2. Keystore Setup (Required for Release)

Create a keystore for signing release builds:

```bash
# Generate keystore
keytool -genkey -v -keystore android/app/keystore/release.keystore \
  -alias driversense \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=driversense
storeFile=keystore/release.keystore
```

**Important**: Never commit `key.properties` or keystore files to version control!

### 3. Google Services (Firebase)

1. Create a Firebase project at https://console.firebase.google.com
2. Add an Android app with package name: `com.driversense.app`
3. Download `google-services.json`
4. Place it in `android/app/`

### 4. Build Flavors

The app supports three build flavors:

| Flavor | Package ID | Description |
|--------|-----------|-------------|
| dev | com.driversense.app.dev | Development |
| staging | com.driversense.app.staging | Staging/QA |
| prod | com.driversense.app | Production |

### 5. Running on Android

```bash
# Development
flutter run --flavor dev

# Staging
flutter run --flavor staging

# Production
flutter run --flavor prod
```

### 6. Building APK/AAB

```bash
# Debug APK
flutter build apk --debug --flavor dev

# Release APK
flutter build apk --release --flavor prod

# App Bundle (for Play Store)
flutter build appbundle --release --flavor prod
```

### 7. Required Permissions

The following permissions are configured in `AndroidManifest.xml`:

- `INTERNET` - API communication
- `ACCESS_FINE_LOCATION` - GPS tracking
- `ACCESS_COARSE_LOCATION` - Network-based location
- `ACCESS_BACKGROUND_LOCATION` - Background GPS
- `FOREGROUND_SERVICE` - Background tracking service
- `CAMERA` - Incident photos
- `RECORD_AUDIO` - Voice recordings
- `RECEIVE_BOOT_COMPLETED` - Auto-start service
- `POST_NOTIFICATIONS` - Push notifications
- `VIBRATE` - Notification vibration

---

## iOS Setup

### 1. Requirements

- **Deployment Target**: iOS 13.0+
- **Xcode**: 15.0+
- **macOS**: Required for iOS development

### 2. Install CocoaPods Dependencies

```bash
cd ios
pod install
cd ..
```

### 3. Bundle Identifier

Update the bundle identifier in Xcode:

| Environment | Bundle ID |
|-------------|-----------|
| Development | com.driversense.app.dev |
| Staging | com.driversense.app.staging |
| Production | com.driversense.app |

### 4. Signing & Capabilities

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities"
4. Select your Team
5. Enable automatic signing or configure manual provisioning

Required capabilities:
- **Background Modes**: Location updates, Background fetch, Remote notifications
- **Push Notifications**
- **Associated Domains** (for deep linking)

### 5. Privacy Permissions

The following usage descriptions are configured in `Info.plist`:

| Permission | Key | Description |
|------------|-----|-------------|
| Location (Always) | NSLocationAlwaysAndWhenInUseUsageDescription | GPS tracking |
| Location (In Use) | NSLocationWhenInUseUsageDescription | GPS tracking |
| Camera | NSCameraUsageDescription | Incident photos |
| Microphone | NSMicrophoneUsageDescription | Voice recordings |
| Photo Library | NSPhotoLibraryUsageDescription | Save/load photos |
| Face ID | NSFaceIDUsageDescription | Biometric login |

### 6. Running on iOS

```bash
# List available simulators
flutter devices

# Run on simulator
flutter run

# Run on physical device
flutter run -d <device-id>
```

### 7. Building for Release

```bash
# Build iOS app
flutter build ios --release

# Open in Xcode for archive
open ios/Runner.xcworkspace
```

Then in Xcode:
1. Select "Product" → "Archive"
2. Once complete, click "Distribute App"
3. Follow the App Store submission flow

---

## App Icons

### Android

Place icon images in the mipmap directories:

```
android/app/src/main/res/
├── mipmap-hdpi/     (72x72)
├── mipmap-mdpi/     (48x48)
├── mipmap-xhdpi/    (96x96)
├── mipmap-xxhdpi/   (144x144)
└── mipmap-xxxhdpi/  (192x192)
```

Or use adaptive icons (recommended):
- Foreground: `drawable/ic_launcher_foreground.xml`
- Background: Define color in `values/colors.xml`

### iOS

Add icon images to `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:

Required sizes:
- iPhone: 40x40, 58x58, 60x60, 80x80, 87x87, 120x120, 180x180
- iPad: 40x40, 58x58, 76x76, 80x80, 152x152, 167x167
- App Store: 1024x1024

**Tip**: Use a tool like https://appicon.co to generate all sizes from a single 1024x1024 image.

---

## Environment Variables

Create environment-specific `.env` files:

```
# .env.dev
API_BASE_URL=https://dev-api.driversense.io
MAPBOX_TOKEN=your_dev_token

# .env.staging
API_BASE_URL=https://staging-api.driversense.io
MAPBOX_TOKEN=your_staging_token

# .env.prod
API_BASE_URL=https://api.driversense.io
MAPBOX_TOKEN=your_prod_token
```

---

## Mapbox Setup

1. Create account at https://www.mapbox.com
2. Get your access token
3. Add to environment config

### Android
Add to `local.properties`:
```
MAPBOX_DOWNLOADS_TOKEN=sk.your_secret_token
```

### iOS
Add to `Info.plist`:
```xml
<key>MGLMapboxAccessToken</key>
<string>pk.your_public_token</string>
```

---

## Firebase Setup

### Android
1. Download `google-services.json` from Firebase Console
2. Place in `android/app/`

### iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place in `ios/Runner/`

---

## Troubleshooting

### Android Issues

**Build fails with "SDK not found"**
```bash
flutter doctor --android-licenses
```

**Gradle sync fails**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS Issues

**Pod install fails**
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install
cd ..
```

**Signing issues**
1. Open Xcode
2. Select Runner target
3. Check "Automatically manage signing"
4. Select your team

**Build fails after Flutter upgrade**
```bash
flutter clean
cd ios
rm Podfile.lock
pod install
cd ..
flutter pub get
```

---

## Next Steps

1. [ ] Add app icons for all sizes
2. [ ] Configure Firebase for your project
3. [ ] Set up Mapbox access tokens
4. [ ] Create signing certificates/keystores
5. [ ] Configure CI/CD (Fastlane, Codemagic, etc.)
6. [ ] Set up crash reporting (Sentry/Crashlytics)
