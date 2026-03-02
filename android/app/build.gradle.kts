plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Una sola volta
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.calcio.campocalcio"
    compileSdk = 35// Imposta il compileSdk direttamente
    ndkVersion = "27.0.12077973" // Imposta la versione NDK direttamente

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.calcio.campocalcio"
        minSdk = 21 // Imposta la tua versione minima SDK
        targetSdk = 34 // Imposta la tua versione target SDK
        versionCode = 1 // Aggiungi un version code
        versionName = "1.0.0" // Aggiungi una version name
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Configurazione di firma
        }
    }
}

flutter {
    source = "../.." // Sostituisci con il percorso relativo al tuo progetto Flutter
}

// Assicurati che il plugin di Google services venga applicato una sola volta
