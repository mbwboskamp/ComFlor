# DriverSense App - Platform Setup Guide

This guide covers the complete setup for both Android and iOS platforms.

---

## 1. Git Installeren

### Windows

1. Download Git van https://git-scm.com/download/win
2. Voer het installatieprogramma uit
3. Kies de standaard opties (of pas aan naar wens)
4. Verifieer installatie:
   ```bash
   git --version
   ```

### macOS

```bash
# Via Homebrew (aanbevolen)
brew install git

# Of via Xcode Command Line Tools
xcode-select --install
```

### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install git
```

### Git Configuratie

```bash
# Configureer je naam en e-mail (verplicht voor commits)
git config --global user.name "Jouw Naam"
git config --global user.email "jouw.email@example.com"

# Optioneel: standaard branch naam instellen
git config --global init.defaultBranch main
```

---

## 2. Visual Studio Code Installeren (Aanbevolen)

VS Code is de aanbevolen editor voor Flutter development vanwege de uitstekende Flutter extensie.

### Windows

1. Download VS Code van https://code.visualstudio.com/download
2. Voer het installatieprogramma uit
3. Selecteer tijdens installatie:
   - "Add to PATH" (aangevinkt laten)
   - "Add 'Open with Code' action" (optioneel maar handig)

### macOS

```bash
# Via Homebrew (aanbevolen)
brew install --cask visual-studio-code

# Of download handmatig van https://code.visualstudio.com/download
```

### Linux (Ubuntu/Debian)

```bash
# Via Snap (aanbevolen)
sudo snap install code --classic

# Of via apt repository:
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
```

### Flutter en Dart Extensies Installeren

1. Open VS Code
2. Ga naar Extensions (Ctrl+Shift+X of Cmd+Shift+X)
3. Zoek "Flutter" en klik Install
   - De Dart extensie wordt automatisch meegeïnstalleerd
4. Herstart VS Code

### Flutter SDK Installeren via VS Code (Alternatieve Methode)

VS Code kan ook de Flutter SDK voor je downloaden:

1. Open VS Code
2. Open Command Palette: `Ctrl+Shift+P` (Windows/Linux) of `Cmd+Shift+P` (macOS)
3. Type "Flutter: New Project" en selecteer het
4. Klik op "Download SDK" wanneer gevraagd
5. Kies een locatie voor de Flutter SDK
6. Klik "Clone Flutter"
7. Klik "Add SDK to PATH" wanneer dit verschijnt

### Handige VS Code Extensies voor Flutter

| Extensie | Beschrijving |
|----------|--------------|
| Flutter | Officiële Flutter ondersteuning |
| Dart | Dart taalondersteuning |
| Pubspec Assist | Dependency management |
| Flutter Widget Snippets | Code snippets |
| Error Lens | Inline error weergave |
| GitLens | Git integratie |

---

## 3. Flutter Installeren (Handmatig)

### Windows

1. **Download Flutter SDK**
   - Ga naar https://docs.flutter.dev/get-started/install/windows
   - Download de laatste stable release (zip bestand)

2. **Uitpakken**
   ```
   Pak uit naar: C:\flutter
   (Vermijd paden met spaties of speciale tekens)
   ```

3. **PATH instellen**
   - Open "Omgevingsvariabelen bewerken" (zoek in Start menu)
   - Onder "Gebruikersvariabelen", selecteer "Path" → "Bewerken"
   - Klik "Nieuw" en voeg toe: `C:\flutter\bin`
   - Klik OK om op te slaan

4. **Verifieer installatie**
   ```bash
   flutter --version
   flutter doctor
   ```

### macOS

```bash
# Via Homebrew (aanbevolen)
brew install --cask flutter

# Of handmatig:
# 1. Download van https://docs.flutter.dev/get-started/install/macos
# 2. Uitpakken naar ~/development/flutter
# 3. Voeg toe aan ~/.zshrc of ~/.bash_profile:
export PATH="$PATH:$HOME/development/flutter/bin"

# Verifieer
flutter --version
flutter doctor
```

### Linux (Ubuntu/Debian)

```bash
# Via Snap (aanbevolen)
sudo snap install flutter --classic

# Of handmatig:
# 1. Download van https://docs.flutter.dev/get-started/install/linux
# 2. Uitpakken naar ~/development/flutter
# 3. Voeg toe aan ~/.bashrc:
export PATH="$PATH:$HOME/development/flutter/bin"

# Verifieer
flutter --version
flutter doctor
```

---

## 4. Android Studio Installeren

### Alle Platforms

1. Download van https://developer.android.com/studio
2. Installeer en start Android Studio
3. Volg de setup wizard:
   - Selecteer "Standard" installatie
   - Accepteer alle licenties

4. **Android SDK instellen**
   - Open Android Studio → Settings → Languages & Frameworks → Android SDK
   - Installeer: Android SDK Platform 34, Android SDK Build-Tools
   - Noteer het SDK pad (bijv. `C:\Users\<naam>\AppData\Local\Android\Sdk`)

5. **Flutter plugin installeren**
   - Settings → Plugins → Marketplace
   - Zoek "Flutter" en installeer (Dart wordt automatisch meegeïnstalleerd)

6. **Android licenties accepteren**
   ```bash
   flutter doctor --android-licenses
   ```

---

## 5. Xcode Installeren (alleen macOS, voor iOS)

1. Open App Store op je Mac
2. Zoek "Xcode" en installeer (dit kan even duren, ~12GB)
3. Open Xcode eenmaal om licentie te accepteren
4. Installeer command line tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

5. Installeer CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

---

## 6. Installatie Verifiëren

Voer `flutter doctor` uit om te controleren of alles correct is geïnstalleerd:

```bash
flutter doctor -v
```

Je zou dit moeten zien (alle groene vinkjes):

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS (alleen op Mac)
[✓] Android Studio
[✓] VS Code (optioneel)
[✓] Connected device
```

Los eventuele problemen op die `flutter doctor` meldt voordat je verdergaat.

---

## 7. Project Setup

### Clone de Repository

```bash
git clone https://github.com/your-org/driversense_app.git
cd driversense_app
```

### Flutter Dependencies Installeren

```bash
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
