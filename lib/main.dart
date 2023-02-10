import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'demo_screen.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(platform: TargetPlatform.android),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform View Loading issue'),
      ),
      body:  Column(
      mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DemoScreen()));
                },
                child: const Text('Demo screen')),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
