import java.util.Properties
import com.android.build.api.dsl.DefaultConfig

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}


val versionProperties = Properties()
val versionPropertiesFile = rootProject.file("version.properties")
if (versionPropertiesFile.exists()) {
    versionProperties.load(versionPropertiesFile.inputStream())
}

fun propOrEnv(key: String): String? {
    return System.getenv(key)          // 1️⃣ check GitHub Actions env
        ?: project.findProperty(key)?.toString()  // 2️⃣ check gradle.properties / project property
        ?: versionProperties.getProperty(key)    // 3️⃣ check local version.properties
}


fun addResValueIfNotEmpty(
    config: DefaultConfig,
    key: String,
    value: String?
) {
    if (!value.isNullOrBlank()) {
        config.resValue("string", key, value)
    }
}

fun logConfig(key: String, value: Any?) {
    val display = when (value) {
        null -> "NOT SET"
        is String -> if (value.isBlank()) "NOT SET" else value
        else -> value.toString()
    }
    println("🔧 CONFIG [$key] = $display")
}

android {
    namespace = "com.example.learn01"
    compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = propOrEnv("APPLICATION_ID") ?: "com.example.learn01"
        logConfig("APPLICATION_ID", applicationId)
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = propOrEnv("APP_VERSION_CODE")?.toInt() ?: 1
        versionName = propOrEnv("APP_VERSION_NAME") ?: "1.0.0"
        logConfig("APP_VERSION_CODE", versionCode)
        logConfig("APP_VERSION_NAME", versionName)
        multiDexEnabled = true

        val appName = propOrEnv("APP_NAME")
        logConfig("APP_NAME", appName)
        addResValueIfNotEmpty(this, "app_name", appName)



    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
