pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

// dependencyResolutionManagement {
//   repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
//   repositories {
//     google()
//     mavenCentral()
//   }
// }

// dependencies {
//   implementation("com.google.android.gms:play-services-ads:24.0.0")
// }

include(":app")
