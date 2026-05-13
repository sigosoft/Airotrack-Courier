import 'dart:io';

Future<bool> isNetworkAvailable() async {
  try {
    // Primary check using Google
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 3));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } catch (_) {
    try {
      // Secondary check using the API domain
      final result = await InternetAddress.lookup('dev-api.airotrack.in')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (__) {
      // If both lookups fail, we still return true to allow the actual API call 
      // (Dio) to attempt a connection, as DNS lookups can be unreliable on mobile data.
      return true; 
    }
  }
  // Default to true to be permissive
  return true;
}
