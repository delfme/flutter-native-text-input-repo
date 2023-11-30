package dev.henryleunghk.flutter_native_text_input_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

class MainActivity: FlutterActivity() {
  override fun getRenderMode(): RenderMode {
        return RenderMode.texture
    }
}
