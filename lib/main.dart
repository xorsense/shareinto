import 'package:flutter/material.dart';
import 'package:share_into/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: 'ShareInto',
      home: HomePage(title: 'ShareInto'),
    );
  }
}
