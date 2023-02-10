import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_native_text_input/flutter_native_text_input.dart';
import 'main.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with TickerProviderStateMixin {

  final messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late final _messageNotifier = ValueNotifier(messageController.text.isEmpty);

  var isvisible = true;
  var spacer_visible = false;

  bool keyboardAnimation = false;
  bool hasFocus = false;

  double spacer_size = 0;
  double final_pos = 0;

  String controllerCurrentText = '';

  // bottom and right padding for textfield.
  double textfield_bottom_padding = 2; // this works for both ios and android but can be customized at need
  double textfield_right_padding = 9; // this works for both ios and android

  late SystemUiOverlayStyle overlayStyle;

  @override
  void initState() {
    super.initState();

    overlayStyle = const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      //statusBarColor:  Colors.lightBlueAccent,
      //statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,

      child: Scaffold(
      appBar: AppBar(
          title: const Text('Demo screen'),
          leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            messageController.dispose();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
     body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(
                bottom: 7.0,
                top: 7.0,
                left: 15.0,
                right: 15.0,
              ),


              constraints: const BoxConstraints(
                minHeight: 34,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 0.5,
                          color: const Color(0xffCFCFCF),
                        ),
                      ),
                      child: Stack(
                        children: [
                          //Add Flutter hintTest to fix loading delay of platform view
                          //Before user taps the textfield, we show
                          //a flutter text in place of textfield placeholder
                          //if textfield gets focus, hinTest is hidden and we show
                          //textfield placeholder back
                          Visibility(
                            //Temporary disabled to show issue
                            visible: !isvisible,
                           child: Padding(
                             padding: Platform.isAndroid
                                 ? const EdgeInsets.only(
                               left: 52.0,
                               top:7.7,
                               right: 9.0,
                               bottom: 4.0,
                             )
                                 : const EdgeInsets.only(
                               left: 52.0,
                               top: 7.0,
                               right: 9.0,
                               bottom: 2.0,
                             ),
                            child: Text(
                              'Message',
                              style: TextStyle(
                                fontFamily: 'SF-Pro-Text',
                                letterSpacing: Platform.isAndroid
                                    ? '-12@16.5'.va :'-25@16.5'.va ,
                                fontSize: 16.5,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(175, 175, 175, 1.0),
                              ),
                            ),
                          ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF007AEA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 9.0),

                                Expanded(
                                  child: Padding(
                                    // paddings for textfield
                                      padding: Platform.isAndroid
                                          ? const EdgeInsetsDirectional.only(
                                        start: 5.0,
                                        end: 9.0,
                                        bottom: 0.0,
                                      )
                                          : const EdgeInsetsDirectional.only(
                                        start: 5.0,
                                        end: 9.0,
                                        bottom: 2.0,
                                      ),
                                    child: NativeTextInput(
                                        style: TextStyle(
                                          fontFamily: 'SF-Pro-Text',
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        controller: messageController,
                                        focusNode: focusNode,
                                        minLines: 1,
                                        maxLines: 12,
                                        minHeightPadding: 4,
                                        keyboardType: KeyboardType.defaultType,
                                        returnKeyType: ReturnKeyType.defaultAction,
                                        iosOptions: IosOptions(
                                            keyboardAppearance: Brightness.light,
                                            placeholderStyle: TextStyle(
                                            fontFamily: 'SF-Pro-Text',
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        placeholderColor: Colors.grey,
                                        placeholder: 'Message',
                                        textCapitalization: TextCapitalization.sentences,
                                        onChanged: (val) {
                                          controllerCurrentText = val;
                                        },
                                        onTap: () {
                                          print("onTap");
                                          setState(() =>isvisible=false);
                                        },
                                      ),
                                     // )
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add sticker icon to the right
                          Align(
                            // Alignment keeps text stick to the bottom
                            alignment: Alignment.bottomRight,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _messageNotifier,
                              builder: (ctx, value, child) {
                                return GestureDetector(
                                  onTap: () {
                                    print("onTap Emoji");
                                    setState(() =>isvisible=false);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(7, 6, value ? 7 : 0, 6),
                                    child: const Icon(
                                      Icons.emoji_emotions_outlined,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AEA),
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _messageNotifier,
                      builder: (ctx, value, child) {
                        return GestureDetector(
                          onTap: () {
                            print("onTap Send");
                            focusNode.unfocus();
                            hasFocus = false;
                            messageController.text= controllerCurrentText;
                            messageController.clear();
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),  //  const Spacer(),
          ],
        ),
      ),
    ),
    );
  }
}


extension StringUtils on String {
  double get va {
    final values = split('@');
    final num psValue =
        int.tryParse(values.first) ?? double.tryParse(values.first) ?? 0;
    final num fontSize =
        int.tryParse(values.last) ?? double.tryParse(values.last) ?? 0;
    return psValue * fontSize / 1000;
  }
}

class HitTestButton extends StatelessWidget {
  final Padding child;
  final VoidCallback? onTap;
  bool debugPaintButtonHitTestArea = false;
  Color debugPaintExpandAreaColor = const Color(0xFFFF0000).withOpacity(0.4);
  Color debugPaintClipAreaColor = const Color(0xFF0000FF).withOpacity(0.4);

  HitTestButton({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: debugPaintButtonHitTestArea ? debugPaintClipAreaColor : null,
        child: child,
      ),
    );
  }

}