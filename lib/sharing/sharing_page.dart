import 'package:flutter/material.dart';

class SharingPage extends StatefulWidget {
  late String sharedUrl;

  SharingPage({super.key, required this.sharedUrl});

  @override
  SharingPageState createState() => SharingPageState();
}

class SharingPageState extends State<SharingPage> {
  String searchTerm = '';
  List<String> paths = [];

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const Text('Share', textScaleFactor: 1.25,),
      TextFormField(
        initialValue: widget.sharedUrl,
      ),
      Text('Shared Url: ${widget.sharedUrl}'),
      const Divider(),
      const Text('Append To', textScaleFactor: 1.25),
      TextField(
        autofocus: true,
        onChanged: (String value) {},
      ),
      Column(children: paths.map((e) => Text(e)).toList()),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.file_upload_rounded),
                Text('Create a New File')
              ],
            )
          )
        ),
    ]);
  }
}
