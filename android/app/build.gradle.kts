import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "sa.rezende.cinform_online_news"
    compileSdk = 34 // Define compileSdkVersion explicitly
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "sa.rezende.cinform_online_news"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21 // Define minSdkVersion explicitly
        targetSdk = 34 // Define targetSdkVersion explicitly
        versionCode = 1 // Define versionCode explicitly
        versionName = "1.0.0" // Define versionName explicitly
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            // Add your own signing config for the release build.
            // signingConfig = signingConfigs.getByName("debug")
            //  signingConfig = signingConfigs.create("release") {
            //     keyAlias = "your-key-alias"
            //     keyPassword = "your-key-password"
            //     storeFile = file("/path/to/your/keystore.jks")
            //     storePassword = "your-store-password"
            // }
        }
    }
}

flutter {
    source = "../.."
}
