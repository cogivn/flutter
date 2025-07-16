package dev.vietnam.flutter_base

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        context.ifGestureMode { enableEdgeToEdge() }
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dev.vietnam.flutter_base/navigation-mode"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getNavigationMode") {
                val mode = CompatUtils.getNavigationBarInteractionMode(this)
                result.success(mode)
            }
        }
    }
}
