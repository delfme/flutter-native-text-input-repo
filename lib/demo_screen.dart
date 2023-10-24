import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> with TickerProviderStateMixin {

  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final _controllerNotifier = ValueNotifier(_controller.text.isEmpty);

  bool hasFocus = false;
  double bottomPadding = 6.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Layout Demo'),
      ),
      body:
      SafeArea(
       // maintainBottomViewPadding: true,
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
          AnimatedContainer(
             duration: Duration(milliseconds: 10),
             curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.only(
                bottom: bottomPadding,
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

                             //Flutter Texfield for demo
                              child: TextFormField(
                                controller: _controller,
                                keyboardType: TextInputType.multiline,
                                textCapitalization:
                                TextCapitalization.sentences,
                                focusNode:_focusNode,
                                onTap: () {},
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: "Message",
                                ),
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

