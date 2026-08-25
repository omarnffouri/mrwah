import 'package:flutter/material.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PartnerWebView extends StatefulWidget {
  final String url;

  const PartnerWebView({super.key, required this.url});

  @override
  State<PartnerWebView> createState() => _PartnerWebViewState();
}

class _PartnerWebViewState extends State<PartnerWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (error) {
            AppSnackBar.error(
              'Could not load page',
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Partner Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1B45),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0E1B45),
              ),
            ),
        ],
      ),
    );
  }
}
