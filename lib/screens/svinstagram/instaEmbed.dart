import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class InstaEmbed extends StatefulWidget {
  final String instaUrl;

  const InstaEmbed({Key key, this.instaUrl}) : super(key: key);

  @override
  _InstaEmbedState createState() => _InstaEmbedState();
}

class _InstaEmbedState extends State<InstaEmbed> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: WebView(
        initialUrl: widget.instaUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
