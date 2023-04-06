import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_into/library/library_page.dart';
import 'package:share_into/managing/managing_page.dart';
import 'package:share_into/sharing/sharing_page.dart';
import 'package:share_into/url_service.dart';

class HomePage extends StatefulWidget {
  late String title;

  HomePage({super.key, required this.title});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String sharedUrl = '';
  bool sharing = false;
  int currentPanelIndex = 0;

  @override
  void initState() {
    super.initState();
    UrlService()
      ..onUrlReceived = handleSharedUrl
      ..getSharedUrl().then(handleSharedUrl);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> panels = [
      LibraryPage(),
      const ManagingPage(),
    ];
    Widget body = sharing
        ? SharingPage(sharedUrl: sharedUrl)
        : panels.elementAt(currentPanelIndex);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library_rounded), label: "Library"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
        currentIndex: currentPanelIndex,
        onTap: (index) {
          setState(() {
            currentPanelIndex = index;
          });
        },
      ),
    );
  }

  void handleSharedUrl(String url) {
    log('url: $url');
    if (url.isNotEmpty) {
      setState(() {
        sharedUrl = url;
        sharing = true;
      });
    }
  }
}
