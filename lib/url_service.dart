import 'package:flutter/services.dart';

class UrlService {
  void Function(String)? onUrlReceived;

  UrlService() {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message?.contains("resumed") ?? false) {
        getSharedUrl().then((value) => {
          if (value.isNotEmpty) {
            onUrlReceived?.call(value)
          }
        });
      }
      return;
    });
  }

  Future<String> getSharedUrl() async {
      return await const MethodChannel('com.xorsense.apps.share_into')
          .invokeMethod('getSharedUrl') ?? "";
  }
}