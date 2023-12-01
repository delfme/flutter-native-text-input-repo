import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/scheduler.dart';


enum ReturnKeyType {
  defaultAction,
  go,
  google,
  join,
  next,
  route,
  search,
  send,
  yahoo,
  done,
  emergencyCall,
  continueAction,
}

enum TextContentType {
  name,
  namePrefix,
  givenName,
  middleName,
  familyName,
  nameSuffix,
  nickname,
  jobTitle,
  organizationName,
  location,
  fullStreetAddress,
  streetAddressLine1,
  streetAddressLine2,
  addressCity,
  addressState,
  addressCityAndState,
  sublocality,
  countryName,
  postalCode,
  telephoneNumber,
  emailAddress,
  url,
  creditCardNumber,
  username,
  password,
  newPassword, // iOS12+
  oneTimeCode // iOS12+
}

enum KeyboardType {
  /// Default type for the current input method.
  defaultType,

  /// Displays a keyboard which can enter ASCII characters
  asciiCapable,

  /// Numbers and assorted punctuation.
  numbersAndPunctuation,

  /// A type optimized for URL entry (shows . / .com prominently).
  url,

  /// A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN
  numberPad,

  /// A phone pad (1-9, *, 0, #, with letters under the numbers).
  phonePad,

  /// A type optimized for entering a person's name or phone number.
  namePhonePad,

  /// A type optimized for multiple email address entry (shows space @ . prominently).
  emailAddress,

  /// A number pad with a decimal point. iOS 4.1+.
  decimalPad,

  /// A type optimized for twitter text entry (easy access to @ #).
  twitter,

  /// A default keyboard type with URL-oriented addition (shows space . prominently).
  webSearch,

  // A number pad (0-9) that will always be ASCII digits. Falls back to KeyboardType.numberPad below iOS 10.
  asciiCapableNumberPad
}

class IosOptions {
  /// Whether autocorrect is enabled.
  ///
  /// Default: null
  final bool? autocorrect;

  /// The color of the cursor
  /// (https://api.flutter.dev/flutter/material/TextField/cursorColor.html)
  ///
  /// Default: null
  final Color? cursorColor;

  /// Name of the font to use for the text, e.g. 'Noteworthy'.
  ///
  /// If this is set, the weight information in `style` is not
  /// used.
  ///
  /// See also:
  /// [placeholderFontName]
  ///
  /// Default: null
  final String? fontName;

  /// The appearance of the keyboard
  /// (https://api.flutter.dev/flutter/material/TextField/keyboardAppearance.html)
  ///
  /// Default: null
  final Brightness? keyboardAppearance;

  /// The style to use for the placeholder text. [Only `fontSize`, `fontWeight` are supported]
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholderStyle.html)
  ///
  /// See also:
  /// [fontName]
  /// [placeholderFontName]
  ///
  /// Default: null
  final TextStyle? placeholderStyle;

  /// Name of the font to use for the placeholder text, e.g. 'Noteworthy'.
  ///
  /// If this is set, the weight information is in [placeholderStyle] is not
  /// used.
  ///
  /// See also:
  /// [fontName]
  /// [placeholderStyle]
  ///
  /// Default: null
  final String? placeholderFontName;

  IosOptions({
    this.autocorrect,
    this.cursorColor,
    this.keyboardAppearance,
    this.placeholderStyle,
    this.fontName,
    this.placeholderFontName,
  });
}



class NativeTextInput extends StatefulWidget {

  static const viewType = 'flutter_native_text_input';

  const NativeTextInput({
    Key? key,
    this.controller,
    this.maxLines = 12,
    this.minLines = 1,
    this.placeholder,
    this.placeholderColor,
    this.style,
    this.textAlign = TextAlign.start,
    this.iosOptions,
    this.textCapitalization = TextCapitalization.none,
    this.textContentType,
    this.keyboardType = KeyboardType.defaultType,
    this.returnKeyType = ReturnKeyType.done,
    this.decoration,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.onReturnKey,
    this.cursorAtEndPosition,
    this.cursorNotAtEndPosition,
    this.onDidChangeSelection,
    this.onLinesCountChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onDispose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NativeTextInputState();

  // Expose current number of Lines
  static int? currentLineCount() {
    return _NativeTextInputState.currentLineCount;
  }

  static void showPlaceholderLightTheme() async {
    //debugPrint("setPlaceholderColor");
    //we call "showPlaceholder" on native side
    _NativeTextInputState.widgetChannel.invokeMethod("showPlaceholderLightTheme");

  }

  static void showPlaceholderNightTheme() async {
    //debugPrint("setPlaceholderColor");
    //we call "showPlaceholder" on native side
    _NativeTextInputState.widgetChannel.invokeMethod("showPlaceholderNightTheme");
  }


  /// Controlling the text being edited
  /// (https://api.flutter.dev/flutter/material/TextField/controller.html)
  ///
  /// Default: null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget
  /// (https://api.flutter.dev/flutter/material/TextField/focusNode.html)
  ///
  /// Default: null
  final FocusNode? focusNode;

  /// Called when the user initiates a change to text entry
  /// (https://api.flutter.dev/flutter/material/TextField/onChanged.html)
  ///
  /// Default: null
  final ValueChanged<String>? onChanged;

  /// Called when the user taps the field.
  ///
  /// Default: null
  final VoidCallback? onTap;

  final VoidCallback? onReturnKey;
  final VoidCallback? cursorAtEndPosition;
  final VoidCallback? cursorNotAtEndPosition;

  /// Called when the user is selecting text inside textfield
  final VoidCallback?  onDidChangeSelection;

  final VoidCallback? onLinesCountChanged;

  /// Called when the widget is disposed
  ///
  /// Default: null
  final VoidCallback? onDispose;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  /// (https://api.flutter.dev/flutter/material/TextField/onEditingComplete.html)
  ///
  /// Default: null
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates that they are done editing the text in the field
  /// (https://api.flutter.dev/flutter/material/TextField/onSubmitted.html)
  ///
  /// Default: null
  final ValueChanged<String?>? onSubmitted;

  /// Minimum number of lines of text input widget
  ///
  /// Default: 1
  final int minLines;

  /// The maximum number of lines to show at one time, wrapping if necessary
  /// (https://api.flutter.dev/flutter/material/TextField/maxLines.html)
  ///
  final int maxLines;

  /// Placeholder text when text entry is empty
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholder.html)
  ///
  /// Default: null
  final String? placeholder;

  /// The text color to use for the placeholder text
  ///
  /// Default: null
  final Color? placeholderColor;

  /// The style to use for the text being edited [Only `fontSize`, `fontWeight`, `color` are supported]
  /// (https://api.flutter.dev/flutter/material/TextField/style.html)
  ///
  /// See also: `fontName` in [IosOptions].
  ///
  /// Default: null
  final TextStyle? style;

  /// iOS only options (cursorColor, keyboardAppearance)
  ///
  /// Default: null
  final IosOptions? iosOptions;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard
  /// (https://api.flutter.dev/flutter/material/TextField/textCapitalization.html)
  ///
  /// Default: TextCapitalization.none
  final TextCapitalization textCapitalization;

  /// To identify the semantic meaning expected for a text-entry area
  /// (https://developer.apple.com/documentation/uikit/uitextcontenttype)
  ///
  /// Default: null
  final TextContentType? textContentType;

  /// How the text should be aligned horizontally
  /// (https://api.flutter.dev/flutter/material/TextField/textAlign.html)
  ///
  /// Default: TextAlign.start
  final TextAlign textAlign;

  /// Controls the BoxDecoration of the box behind the text input
  /// (https://api.flutter.dev/flutter/cupertino/CupertinoTextField/decoration.html)
  ///
  /// Default: null
  final BoxDecoration? decoration;

  /// Constants that specify the text string that displays in the Return key of a keyboard
  /// (https://developer.apple.com/documentation/uikit/uireturnkeytype)
  ///
  /// Default: ReturnKeyType.defaultAction
  final ReturnKeyType returnKeyType;

  /// Type of keyboard to display for a given text-based view
  /// (https://developer.apple.com/documentation/uikit/uikeyboardtype)
  ///
  /// Default: KeyboardType.defaultType
  final KeyboardType keyboardType;

}

class _NativeTextInputState extends State<NativeTextInput> {

  final Completer<MethodChannel> _channel = Completer();
  int _cursor = 0;
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? (_controller ??= TextEditingController());

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  //widgetChannel is used to expose focus via requestFocus function
  static var widgetChannel;

  // _lineHeight is used for _contentHeight, _minHeight and _maxHeight
  late double _lineHeight;

  // _contentHeight is textfield height, it must change dynamically to support multi-lines mode.
  late double _contentHeight;

  // a multiplier used to correct _lineHeight value
  double multiplier = 1.2;

  static int currentLineCount = 1;


  @override
  void initState()  {
    super.initState();
    _effectiveFocusNode.addListener(_focusNodeListener);
    widget.controller?.addListener(_controllerListener);
    // initiate _lineHeight and _contentHeight
    if((widget.style != null && widget.style?.fontSize != null)){
      _lineHeight = widget.style!.fontSize!;
    }
    else {
      _lineHeight = 17;
    }

    _contentHeight = Platform.isAndroid? ((_lineHeight * multiplier) * widget.minLines)
        : (21.5 * widget.minLines);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  void _createMethodChannel(int nativeViewId) async {
    MethodChannel channel =
    MethodChannel("flutter_native_text_input$nativeViewId")
      ..setMethodCallHandler(_onMethodCall);

    widgetChannel = channel;

    // Set text
    channel.invokeMethod(
      "setText",
      {"text": widget.controller?.text ?? '', "cursorPos": _cursor},
    );

    channel.invokeMethod("getLineHeight").then((value) {
      if (value != null) {
        setState(() {
          _lineHeight = value;
        });
      }
    });

    channel.invokeMethod("currentLineCount").then((value) {
      final intValue = value.ceil();
      if (intValue != null) {
        if (intValue != currentLineCount) {
          setState(() {
            currentLineCount = intValue;
          });
          widget.onLinesCountChanged?.call();
        }
      }
    });

    // Get contentHeight
    channel.invokeMethod("getContentHeight").then((value) {
      if (mounted && value != null && value != _contentHeight) {
        setState(() {
          _contentHeight = value;
        });
      }
    });

    _channel.complete(channel);

  }

  Future<bool?> _onMethodCall(MethodCall call) async {
    switch (call.method) {

      case "inputValueChanged":
        final String? text = call.arguments["text"];
        final int? lineIndex = call.arguments["currentLine"];

        if (defaultTargetPlatform == TargetPlatform.iOS) {
          final String? textChange = call.arguments["textChange"];
          final int cursorPos = call.arguments["cursorPos"];
          _inputValueChanged(text, textChange, lineIndex, cursorPos);
        } else {
          final int cursorPos = call.arguments["cursorPos"];
          _inputValueChanged(text, "", lineIndex, cursorPos);
        }

        return null;

      case "inputStarted":
        _inputStarted();
        return null;

      case "inputFinished":
        final String? text = call.arguments["text"];
        _inputFinished(text);
        return null;

      case "cursorNotAtEndPosition":
        _cursorNotAtEndPosition();
        return null;

      case "cursorAtEndPosition":
        _cursorAtEndPosition();
        return null;

      case "onReturnKey":
        debugPrint("onReturnKey");
        widget.onReturnKey?.call();
        return null;


      case "singleTapRecognized":
        final channel = await _channel.future;
        channel.invokeMethod("currentLineCount").then((value) {
          final intValue = value.ceil();
          if (intValue != null) {
            if(intValue != currentLineCount) {
              currentLineCount = intValue;
              widget.onLinesCountChanged?.call();
            }
          }
        });

        _singleTapRecognized();
        return null;

      case "didChangeSelection":
        _didChangeSelectiond();
        return null;

    }
    throw MissingPluginException(
        "NativeTextInput._onMethodCall: No handler for ${call.method}");
  }


  Map<String, dynamic> _buildCreationParams(BoxConstraints constraints) {
    Map<String, dynamic> params = {
      "maxLines": widget.maxLines,
      "minLines": widget.minLines,
      "placeholder": widget.placeholder ?? "",
      "returnKeyType": widget.returnKeyType.toString(),
      "text": _effectiveController.text.trim(),
      "textCapitalization": widget.textCapitalization.toString(),
      "textContentType": widget.textContentType?.toString(),
      "keyboardAppearance": widget.iosOptions?.keyboardAppearance.toString(),
      "keyboardType": widget.keyboardType.toString(),
      "width": constraints.maxWidth,
    };

    if (widget.style != null && widget.style?.fontSize != null) {
      params = {
        ...params,
        "fontSize": widget.style?.fontSize,
      };
    }

    if (widget.style != null && widget.style?.fontWeight != null) {
      params = {
        ...params,
        "fontWeight": widget.style?.fontWeight.toString(),
      };
    }


    if (widget.style != null && widget.style?.color != null) {
      params = {
        ...params,
        "fontColor": {
          "red": widget.style?.color?.red,
          "green": widget.style?.color?.green,
          "blue": widget.style?.color?.blue,
          "alpha": widget.style?.color?.alpha,
        }
      };
    }


    if (widget.placeholderColor != null) {
      params = {
        ...params,
        "placeholderFontColor": {
          "red": widget.placeholderColor?.red,
          "green": widget.placeholderColor?.green,
          "blue": widget.placeholderColor?.blue,
          "alpha": widget.placeholderColor?.alpha,
        },
      };
    }


    if (widget.onTap != null) {
      params = {
        ...params,
        "onTap": true,
      };

    }
    return params;
  }

  Widget _platformView(BoxConstraints layout) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: NativeTextInput.viewType,
          surfaceFactory: (context, controller) => AndroidViewSurface(
            controller: controller as AndroidViewController,
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          ),
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: NativeTextInput.viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: _buildCreationParams(layout),
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  if (!_effectiveFocusNode.hasFocus) {
                    _effectiveFocusNode.requestFocus();
                  }
                })
              ..addOnPlatformViewCreatedListener((_) {
                params.onPlatformViewCreated(_);
                _createMethodChannel(_);
              })
              ..create();
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: NativeTextInput.viewType,
          layoutDirection: TextDirection.ltr,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: _buildCreationParams(layout),
          onPlatformViewCreated: _createMethodChannel,
        );
      default:
        return CupertinoTextField(
          controller: widget.controller,
          cursorColor: widget.iosOptions?.cursorColor,
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: Colors.transparent),
          ),
          focusNode: widget.focusNode,
          keyboardAppearance: widget.iosOptions?.keyboardAppearance,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          placeholder: widget.placeholder,
          placeholderStyle: TextStyle(color: widget.placeholderColor),
          //   textAlign: widget.textAlign,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        );
    }

  }


  @override
  Widget build(BuildContext context) {
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    return ConstrainedBox(
      constraints: BoxConstraints(
        // Normalize constraint to guarantee that _maxHeight > _minHeight
        minHeight: _minHeight,
        maxHeight: (_maxHeight < _minHeight) ? _minHeight : _maxHeight,

      ),
      child: LayoutBuilder(
        builder: (context, layout) => Container(
          decoration:   BoxDecoration(
            border: Border.all(width: 0, color: Colors.transparent),
          ),
          child: _platformView(layout),
        ),
      ),
    );

  }


  Future<void> _focusNodeListener() async {
    //debugPrint('_focusNodeListener');
    final MethodChannel channel = await _channel.future;
    if (mounted) {
      channel.invokeMethod(_effectiveFocusNode.hasFocus ? "focus" : "unfocus");
    }
  }


  Future<void> _controllerListener() async {
    final MethodChannel channel = await _channel.future;
    channel.invokeMethod(
      "setText",
      {"text": widget.controller?.text ?? '', "cursorPos": _cursor},
    );

    // Get currentLineCount
    channel.invokeMethod("currentLineCount").then((value) {
      final intValue = value.ceil();
      if (intValue != null) {
        if (intValue != currentLineCount) {
          setState(() {
              currentLineCount = intValue;
          });
          widget.onLinesCountChanged?.call();
        }
      }
    });

    // Get contentHeight
    channel.invokeMethod("getContentHeight").then((value) {
      if (mounted && value != null && value != _contentHeight) {
        setState(() {
          _contentHeight = value;
        });
      }
    });
  }


  void _inputStarted() {
    if (!_effectiveFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    }
  }


  void _inputFinished(String? text) async {
    final channel = await _channel.future;
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!();
    } else {
      channel.invokeMethod("unfocus");
      if (_effectiveFocusNode.hasFocus && mounted) FocusScope.of(context).unfocus();
    }
    if (widget.onSubmitted != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      widget.onSubmitted!(text);
    }
  }


  void _inputValueChanged(
      String? text, String? textChange, int? lineIndex, int currentPos) async {
    if (text == null) {
      return;
    }

    if (currentPos == text.length ||
        (currentPos - text.length == 150)) {
      _cursorAtEndPosition();
    } else {
      _cursorNotAtEndPosition();
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _cursor = currentPos;
      _effectiveController.text = textChange!;
      if (widget.onChanged != null) widget.onChanged!(textChange);
    } else {
      _cursor = currentPos;
      if (widget.onChanged != null) widget.onChanged!(text);

    }

    final channel = await _channel.future;

    channel.invokeMethod("currentLineCount").then((value) {
      final intValue = value.ceil();
      if (intValue != null) {
        if(intValue != currentLineCount) {
          currentLineCount = intValue;
          widget.onLinesCountChanged?.call();
        }
      }
    });

    channel.invokeMethod("getContentHeight").then((value) {
      if (mounted && value != null && value != _contentHeight) {
        setState(() {
          _contentHeight = value;
        });
      }
    });

  }

  void _singleTapRecognized() => widget.onTap?.call();
  void _cursorNotAtEndPosition() => widget.cursorNotAtEndPosition?.call();
  void _cursorAtEndPosition() => widget.cursorAtEndPosition?.call();
  void _didChangeSelectiond() => widget.onDidChangeSelection?.call();

  double get _minHeight => (widget.minLines * _lineHeight);

  double get _maxHeight {
    if (_contentHeight > _minHeight) {
      double maxBoxHeight = widget.maxLines * _lineHeight;
      if (_lineHeight * currentLineCount <= maxBoxHeight) {
          return _contentHeight;
      } else {
        return maxBoxHeight;
      }
    }

    return _minHeight;
  }

}
