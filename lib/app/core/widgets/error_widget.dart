import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? code;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.code, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorIllustration(code),
          Text(
            _getUserFriendlyMessage(message, code),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (onRetry != null)
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
        ],
      ),
    );
  }
}

String _getUserFriendlyMessage(String message, String? code) {
  if (code == '404') {
    return 'The requested resource was not found.';
  } else if (code == '401') {
    return 'You are not authorized to access this resource.';
  } else if (code == '403') {
    return 'You are forbidden from accessing this resource.';
  } else if (code == '500') {
    return 'An internal server error occurred.';
  } else {
    return message;
  }
}

Widget _buildErrorIllustration(String? code) {
  if (code == '404') {
    return const Icon(
      Icons.error_outline,
      size: 100,
      color: Colors.red,
    );
  } else if (code == '401' || code == '403') {
    return const Icon(
      Icons.lock,
      size: 100,
      color: Colors.red,
    );
  } else if (code == '500') {
    return const Icon(
      Icons.error,
      size: 100,
      color: Colors.red,
    );
  } else {
    return const Icon(
      Icons.error_outline,
      size: 100,
      color: Colors.red,
    );
  }
}
