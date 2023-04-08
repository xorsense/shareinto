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
  String content = '';
  String searchTerm = '';
  List<String> paths = [];
  String filePath = '';

  Future<List<String>> getPaths() async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    Directory unsortedDir = Directory('${baseDir.path}/files/unsorted');
    if (!unsortedDir.existsSync()) {
      unsortedDir.createSync(recursive: true);
    }
    paths = unsortedDir.listSync().map((e) => e.path).toList();
    setPaths(paths);
    return paths;
  }

  setPaths(List<String> paths) {
    setState(() {
      paths = paths;
    });
  }

  List<Widget> mapPaths(List<String> paths) =>
      paths.map((e) => Text(e)).toList();

  saveInto(String newContent, String filePath) {
    if (newContent.isEmpty || filePath.isEmpty) {
      throw ExceptionSharingSaveTo();
    }
    File file = File(filePath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    String oldContent = file.readAsStringSync();
    String contents = '$oldContent\n$newContent';
    file.writeAsStringSync(contents);
  }

  @override
  Widget build(BuildContext context) {
    content = '- ${widget.sharedUrl}';

    return ListView(children: [
      const Text(
        'Share Markdown',
        textScaleFactor: 1.25,
      ),
      TextFormField(
        initialValue: content,
        onChanged: (String value) {
          setState(() {
            content = value;
          });
        },
      ),
      Text('Shared Url: ${widget.sharedUrl}'),
      const Divider(),
      const Text('Append To', textScaleFactor: 1.25),
      TextField(
        autofocus: true,
        onChanged: (String value) async {
          Directory baseDir = await getApplicationDocumentsDirectory();
          Directory unsortedDir = Directory('${baseDir.path}/files/unsorted');
          setState(() {
            searchTerm = value;
            filePath = '${unsortedDir.path}/${value}.md';
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
              onPressed: () {
                String notice = '';
                try {
                  saveInto(content, filePath);
                  notice = '$filePath created';
                } on ExceptionSharingSaveTo {
                  notice = 'there was a problem saving the share';
                } catch (e) {
                  notice = e.toString();
                } finally {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(notice)));
                }
              },
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

class ExceptionSharingSaveTo implements Exception {
  String? message = 'exception in saveTo';
  ExceptionSharingSaveTo({this.message}) {}
}
