import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_playground/change_notifier/counter_screen.dart';
import 'package:provider_playground/change_notifier/counter_view_model.dart';

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
      home: ProviderWrapper()
    );
  }
}
