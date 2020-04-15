import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:odyssee/shared/header_nav.dart';

class OdysseeWebExplorer extends StatefulWidget {
  @override
  OdysseeWebExplorerState createState() => OdysseeWebExplorerState();
}

class OdysseeWebExplorerState extends State<OdysseeWebExplorer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('Odyssee Web View'),
        appBar: AppBar(),
      ),
      drawer: BaseDrawer(),
      body: WebView(
        initialUrl: "https://odyssee-nature.github.io/#",
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class PlayWebExplorer extends StatefulWidget {
  @override
  PlayWebExplorerState createState() => PlayWebExplorerState();
}

class PlayWebExplorerState extends State<PlayWebExplorer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('Odyssee Web View'),
        appBar: AppBar(),
      ),
      drawer: BaseDrawer(),
      body: WebView(
        initialUrl: "https://odyssee-nature.github.io/#intro",
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}