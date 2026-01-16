# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Dio
-keep class com.squareup.okhttp3.** { *; }
-keep interface com.squareup.okhttp3.** { *; }

# Drift/SQLite
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep model classes
-keep class com.driversense.app.models.** { *; }

# Mapbox
-keep class com.mapbox.** { *; }
-dontwarn com.mapbox.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# General Android
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
