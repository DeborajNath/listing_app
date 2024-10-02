import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Linkedin extends StatefulWidget {
  const Linkedin({super.key});

  @override
  State<Linkedin> createState() => _LinkedinState();
}

class _LinkedinState extends State<Linkedin> {
  double progress = 0;
  late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await inAppWebViewController.canGoBack();

        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri("https://in.linkedin.com/company/girmantech")),
                onWebViewCreated: (InAppWebViewController controller) {
                  inAppWebViewController = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progressDone) {
                  setState(() {
                    progress = progressDone / 100;
                  });
                },
              ),
              progress < 1
                  ? Container(
                      child: LinearProgressIndicator(
                        value: progress,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
