plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

project.extra["envConfigFiles"] = mapOf(
    "alpha" to "env/.env.alpha",
    "dev" to "env/.env.dev",
    "prg" to "env/.env.prg",
    "uat" to "env/.env.uat",
    "prd" to "env/.env.prd"
)

apply(from = "${project(":flutter_config").projectDir}/dotenv.gradle")

android {
    namespace = "dev.vietnam.flutter_base"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    buildFeatures.buildConfig = true
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = project.extra["env"]?.let { (it as Map<*, *>)["PACKAGE_NAME"] } as String
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "build_config_package", "dev.vietnam.flutter_base")
    }

    signingConfigs {
        create("release") {
            storeFile = file("../key/mightybush2017.jks")
            storePassword = "mightybush2017"
            keyAlias = "mightybush2017"
            keyPassword = "mightybush2017"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            isShrinkResources = true
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    flavorDimensions += "environment"
    productFlavors {
        create("alpha") { dimension = "environment" }
        create("dev") { dimension = "environment" }
        create("prg") { dimension = "environment" }
        create("uat") { dimension = "environment" }
        create("prd") { dimension = "environment" }
    }
}

flutter {
    source = "../.."
}

dependencies {
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.1.4")
}