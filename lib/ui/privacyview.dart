import 'package:daily_diary/allwidgets/button.dart';
import 'package:daily_diary/allwidgets/text.dart';
import 'package:daily_diary/constant/statics.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({super.key, required this.title, required this.url});
  final String title;
  final String url;
  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  late WebViewController webViewController;
  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const Back(),
        title: TextModel(widget.title, textStyle: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
