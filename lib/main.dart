import 'package:flutter/material.dart';
import 'package:provider_playground/Consumer/counter_screen.dart';
import 'package:provider_playground/FutureProvider/coutner_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderWrapper6(),
    );
  }
}
