import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_text_input/flutter_native_text_input.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {

  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final _controllerNotifier = ValueNotifier(_controller.text.isEmpty);

  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Chat Layout Demo'),
      ),
      body:
      SafeArea(
        //maintainBottomViewPadding: false,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  color: Colors.brown,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 6.0,
                top: 6.0,
                left: 15.0,
                right: 15.0,
              ),
              constraints: const BoxConstraints(
                minHeight: 36,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                          width: 0.5,
                          color: const Color(0xffCFCFCF),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Plus icon
                          Container(
                            margin: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF007AEA),
                              shape: BoxShape.circle,
                            ),
                            width: 24,
                            height: 24,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:0, right:8),

                            /*
                              // Flutter Texfield
                              child: TextFormField(
                                controller: _controller,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                TextCapitalization.sentences,
                                focusNode: _focusNode,
                                onTap: () {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: "Message",
                                ),
                              ),
                              */

                              // PlatformView Native Textfield
                              child: NativeTextInput(
                                controller: _controller,
                                focusNode: _focusNode,
                                minLines: 1,
                                maxLines: 12,
                                style: TextStyle(
                                  fontFamily: 'SF-Pro-Text',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                placeholderColor: Color.fromRGBO(175, 175, 175, 1),
                                placeholder: 'Message',
                                keyboardType: KeyboardType.defaultType,
                                returnKeyType: ReturnKeyType.defaultAction,
                                iosOptions: IosOptions(
                                  keyboardAppearance: Brightness.light,
                                ),
                                textCapitalization: TextCapitalization.sentences,
                                onTap: () {},
                              ),


                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _controllerNotifier,
                            builder: (ctx, value, child) {
                              if (value) {
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                                  child: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Color(0xFF9E9E9E),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  // Send button
                  Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AEA),
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _controllerNotifier,
                      builder: (ctx, value, child) {
                        return GestureDetector(
                          onTap: () {
                            print("onTap Send");
                            _focusNode.unfocus();
                            hasFocus = false;
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(8, 7, 6, 7),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
