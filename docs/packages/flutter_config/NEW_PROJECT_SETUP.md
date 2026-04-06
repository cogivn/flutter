# flutter_config - New Project Setup Guide

**SDLC Version**: 6.1.0  
**Category**: Package  
**Status**: Active

---

## Purpose

This guide lists all files you must update when bootstrapping a new project with `flutter_config`, based on the working setup in this repository.

---

## 1) Add dependency

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter_config:
    git:
      url: https://github.com/cogivn/flutter_config.git
      ref: master
```

---

## 2) Create environment files

Create these files under `env/`:

- `.env.alpha`
- `.env.dev`
- `.env.prg`
- `.env.uat`
- `.env.prd`
- `.env.example`

Minimum keys:

```env
FLAVOR=DEV
PACKAGE_NAME=vn.x9labs.tuktuk
BUNDLE_ID=vn.x9labs.tuktuk
APPLE_TEAM_ID=YOUR_APPLE_TEAM_ID
APP_NAME=[DEV]Tuktuk
API_URL="https://example.tld/api/v1"
```

If you want a single app identity across Android and iOS, keep `PACKAGE_NAME` and `BUNDLE_ID` identical.

---

## 3) Dart initialization

Update startup flow:

- `lib/main.dart`
  - call `WidgetsFlutterBinding.ensureInitialized()`
  - call `await AppEnvironment.setup()` before `runApp`
- `lib/src/common/utils/app_environment.dart`
  - call `FlutterConfig.loadEnvVariables()`
  - expose required keys (`FLAVOR`, `PACKAGE_NAME`, `BUNDLE_ID`, `APP_NAME`, `API_URL`)

---

## 4) Android setup

### Files to update

- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/proguard-rules.pro`
- `android/app/src/main/kotlin/<your/package>/MainActivity.kt`
- `android/app/src/main/kotlin/<your/package>/CompatUtils.kt`
- `android/app/src/main/kotlin/<your/package>/EdgeToEdge.kt`
- `lib/src/common/widgets/edge_to_edge.dart` (MethodChannel name)

### Required changes

1. Map flavors to env files in `build.gradle.kts`:

```kts
project.extra["envConfigFiles"] = mapOf(
    "alpha" to "env/.env.alpha",
    "dev" to "env/.env.dev",
    "prg" to "env/.env.prg",
    "uat" to "env/.env.uat",
    "prd" to "env/.env.prd",
)
```

2. Apply dotenv script:

```kts
apply(from = "${project(":flutter_config").projectDir}/dotenv.gradle")
```

3. Keep package values aligned:

```kts
android {
    namespace = "vn.x9labs.tuktuk"
    defaultConfig {
        applicationId = project.extra["env"]?.let { (it as Map<*, *>)["PACKAGE_NAME"] } as String
        resValue("string", "app_name", project.extra["env"]?.let { (it as Map<*, *>)["APP_NAME"] } as String)
        resValue("string", "build_config_package", "vn.x9labs.tuktuk")
    }
}
```

4. Update manifest activity:

```xml
<activity android:name="vn.x9labs.tuktuk.MainActivity" ... />
```

Also make app label env-driven:

```xml
<application android:label="@string/app_name" ... />
```

5. Protect `BuildConfig` in release minification:

```pro
-keep class vn.x9labs.tuktuk.BuildConfig { *; }
```

6. Keep MethodChannel string identical in Android and Dart:

- Android: `"vn.x9labs.tuktuk/navigation-mode"`
- Dart: `MethodChannel('vn.x9labs.tuktuk/navigation-mode')`

---

## 5) iOS setup

### Files to update

- `ios/Runner.xcodeproj/xcshareddata/xcschemes/*.xcscheme`
- `ios/Flutter/Debug.xcconfig`
- `ios/Flutter/Release.xcconfig`
- `ios/.gitignore`

### Required changes

1. Add pre-actions to each scheme:

- Script 1 (select env file):

```sh
echo "env/.env.dev" > $(dirname $WORKSPACE_PATH)/.envfile
```

Replace by scheme:
- `alpha` -> `env/.env.alpha`
- `dev` -> `env/.env.dev`
- `prg` -> `env/.env.prg`
- `uat` -> `env/.env.uat`
- `prd` -> `env/.env.prd`

- Script 2 (generate tmp xcconfig):

```sh
SRCROOT=$(dirname $WORKSPACE_PATH)
${SRCROOT}/.symlinks/plugins/flutter_config/ios/Classes/BuildXCConfig.rb ${SRCROOT}/ ${SRCROOT}/Flutter/tmp.xcconfig
```

2. Include generated config:

In `ios/Flutter/Debug.xcconfig`:

```xcconfig
#include? "tmp.xcconfig"
```

In `ios/Flutter/Release.xcconfig`:

```xcconfig
#include? "tmp.xcconfig"
```

3. Set app display name from env in `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>$(APP_NAME)</string>
```

4. Ignore generated temporary files:

```gitignore
**/ios/Flutter/tmp.xcconfig
ios/.envfile
```

---

## 6) Quick validation checklist

- No old package string remains in Android and Dart.
- All `env/.env.*` files use the intended `PACKAGE_NAME` and `BUNDLE_ID`.
- Android debug build works:
  - `flutter run --flavor dev`
- Android release build works:
  - `flutter build apk --flavor prd --release`
- iOS scheme picks the correct env file for each flavor.
- Android app label changes when `APP_NAME` changes in env.
- iOS app display name changes when `APP_NAME` changes in env.
