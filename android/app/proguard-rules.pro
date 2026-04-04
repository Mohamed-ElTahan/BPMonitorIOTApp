# Fix R8 missing classes (Java reflection)
-keep class java.lang.reflect.** { *; }
-dontwarn java.lang.reflect.**

# Fix Google / Guava reflection issues
-keep class com.google.common.** { *; }
-dontwarn com.google.common.**

# Flutter wrapper
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase / Firestore
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Keep annotations (important for Firebase + reflection)
-keepattributes *Annotation*

# Keep generic signatures
-keepattributes Signature

# Keep Firestore model classes (Kotlin data classes used with Firestore)
-keepclassmembers class * {
    @com.google.firebase.firestore.PropertyName *;
}
-keepclassmembers class * {
    public <init>();
}

# Kotlin metadata (needed for reflection-based serialization)
-keep class kotlin.Metadata { *; }
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# MQTT Client
-keep class org.eclipse.paho.** { *; }
-dontwarn org.eclipse.paho.**

# OkHttp / networking (used internally by Firebase)
-dontwarn okhttp3.**
-dontwarn okio.**

# Prevent removal of classes used via reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
