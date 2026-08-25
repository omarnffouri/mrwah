import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/shop_detail/views/widgets/shop_payment_sucess.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mrwah/app/modules/booking/views/components/payment_sucess.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  final String bookingType;
  final String? bookingName;
  final String? rentalDate;
  final String? amount;
  final String? total;

  const PaymentWebView({
    super.key,
    required this.url,
    required this.bookingType,
    this.bookingName,
    this.rentalDate,
    this.amount,
    this.total,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _handleUrl(url);
          },
          onPageFinished: (String url) {
            _handleUrl(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            _handleUrl(request.url);
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            print("❌ WEBVIEW ERROR → $error");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _handleUrl(String url) {
    print(url);

    if (url.contains("payment/deposit/success")) {
      if (widget.bookingType == "car") {
        Get.to(() => PaymentSuccessContent(
              carName: widget.bookingName,
              rentalDate: widget.rentalDate,
              amount: widget.amount,
              total: widget.total,
            ));
      } else if (widget.bookingType == "shop") {
        Get.to(() => const ShopPaymentSucess());
      }
    }

    if (url.contains("failed") || url.contains("error")) {
      Get.back();
      AppSnackBar.error(
        "Your payment was not completed",
        title: "Payment Failed",
      );

      return;
    }

    if (url.contains("cancel")) {
      Get.back();
      AppSnackBar.error(
        "Payment was cancelled",
        title: "Cancelled",
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
