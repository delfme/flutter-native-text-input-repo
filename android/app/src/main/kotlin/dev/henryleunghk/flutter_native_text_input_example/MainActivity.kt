package dev.henryleunghk.flutter_native_text_input_example

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  override fun getRenderMode(): RenderMode {
        return RenderMode.texture
    }
}
