import java.util.Properties
import com.android.build.api.dsl.DefaultConfig

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val versionProperties = Properties()
val versionPropertiesFile = rootProject.file("version.properties")
if (versionPropertiesFile.exists()) {
    versionProperties.load(versionPropertiesFile.inputStream())
}else {
    println("⚠️ version.properties NOT FOUND, Local release builds will fail.")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("app/keystore.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
} else {
    println("⚠️ keystore.properties NOT FOUND, Local release builds will fail.")
}

fun propOrEnvVersion(key: String): String? {
    return System.getenv(key)          // 1️⃣ check GitHub Actions env
        ?: project.findProperty(key)?.toString()  // 2️⃣ check gradle.properties / project property
        ?: versionProperties.getProperty(key)    // 3️⃣ check local version.properties
}

fun propOrEnvKeystore(key: String): String? {
    return System.getenv(key)          // 1️⃣ check GitHub Actions env
        ?: project.findProperty(key)?.toString()  // 2️⃣ check gradle.properties / project property
        ?: keystoreProperties.getProperty(key)    // 3️⃣ check local keystore.properties
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
        applicationId = propOrEnvVersion("ANDROID_APP_ID") ?: "com.example.learn01"
        logConfig("ANDROID_APP_ID", applicationId)
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = propOrEnvVersion("APP_VERSION_CODE")?.toInt() ?: 1
        versionName = propOrEnvVersion("APP_VERSION_NAME") ?: "1.0.0"
        logConfig("APP_VERSION_CODE", versionCode)
        logConfig("APP_VERSION_NAME", versionName)
        multiDexEnabled = true

        val appDisplayName = propOrEnvVersion("APP_DISPLAY_NAME")
        logConfig("APP_DISPLAY_NAME", appDisplayName)
        addResValueIfNotEmpty(this, "app_name", appDisplayName)
    }

    flavorDimensions.add("env")

    productFlavors {
        create("dev") {
            dimension = "env"
        }
        create("jioBpPulse") {
            dimension = "env"
        }
    }

    signingConfigs {
        create("release") {
            storeFile = propOrEnvKeystore("STORE_FILE")?.let {
                file(it)
            }
                //keystorePropertiesFile.takeIf { it.exists() }?.let { file(keystoreProperties["storeFile"] as String) }
            storePassword = propOrEnvKeystore("KEYSTORE_PASSWORD")
                //keystoreProperties["storePassword"] as? String
            keyAlias = propOrEnvKeystore("KEY_ALIAS")
                //keystoreProperties["keyAlias"] as? String
            keyPassword = propOrEnvKeystore("KEY_PASSWORD")
                //keystoreProperties["keyPassword"] as? String
            println("🔐 Signing config:")
            println("   storeFile = ${storeFile ?: "NOT SET"}")
            println("   keyAlias = ${keyAlias ?: "NOT SET"}")
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
    implementation("com.google.firebase:firebase-analytics")
}
