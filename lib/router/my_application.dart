import 'package:clock_app/router/router.dart';
import 'package:flutter/material.dart';

class MyApplication extends StatefulWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerMyApp,
    );
  }
}
