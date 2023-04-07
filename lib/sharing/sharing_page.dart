import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SharingPage extends StatefulWidget {
  late String sharedUrl;

  SharingPage({super.key, required this.sharedUrl});

  @override
  SharingPageState createState() => SharingPageState();
}

class SharingPageState extends State<SharingPage> {
  String searchTerm = '';
  List<String> paths = [];

  Future<List<String>> getPaths() async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    return baseDir.listSync().map((e) => e.path).toList();
  }

  List<Widget> mapPaths(List<String> paths) =>
      paths.map((e) => Text(e)).toList();

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const Text(
        'Share Markdown',
        textScaleFactor: 1.25,
      ),
      TextFormField(
        initialValue: '- ${widget.sharedUrl}',
      ),
      Text('Shared Url: ${widget.sharedUrl}'),
      const Divider(),
      const Text('Append To', textScaleFactor: 1.25),
      TextField(
        autofocus: true,
        onChanged: (String value) {
          setState(() {
            searchTerm = value;
          });
        },
      ),
      FutureBuilder(
          future: getPaths(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = mapPaths(snapshot.data!);
            } else {
              children = mapPaths(paths);
            }
            return Column(children: children);
          }),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_upload_rounded),
                  Text('Create $searchTerm.md')
                ],
              ))),
    ]);
  }
}
