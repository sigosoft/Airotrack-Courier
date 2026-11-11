import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_constants.dart';
import '../models/courier_requests_response.dart';

/// Opens and shares the invoice file the backend attaches to a courier
/// request (`invoice` field of `courierRequests`).
class InvoiceHelper {
  InvoiceHelper._();

  /// Full link to the invoice file, or null when the request has none.
  /// The backend may send a full URL or a path relative to the API host.
  static Uri? invoiceUri(CourierRequest? request) {
    final raw = request?.invoice?.trim() ?? '';
    if (raw.isEmpty || raw.toLowerCase() == 'null') return null;

    final parsed = Uri.tryParse(raw);
    if (parsed == null) return null;
    if (parsed.hasScheme) return parsed;

    final path = raw.startsWith('/') ? raw.substring(1) : raw;
    return Uri.tryParse('${ApiConstants.fileBaseUrl}$path');
  }

  static bool hasInvoice(CourierRequest? request) =>
      invoiceUri(request) != null;

  /// Opens the invoice outside the app (PDF viewer / browser), where the
  /// user can view and save it.
  static Future<void> open(CourierRequest? request) async {
    final uri = invoiceUri(request);
    if (uri == null) {
      _showNotAvailable();
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      Get.snackbar(
        'Error',
        'Could not open the invoice. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<void> share(CourierRequest? request) async {
    final uri = invoiceUri(request);
    if (uri == null) {
      _showNotAvailable();
      return;
    }
    final number = request?.invoiceNumber?.trim() ?? '';
    final title = number.isEmpty ? 'Invoice' : 'Invoice $number';
    await SharePlus.instance.share(
      ShareParams(text: '$title\n$uri', subject: title),
    );
  }

  static void _showNotAvailable() {
    Get.snackbar(
      'Invoice',
      'No invoice is available for this allocation.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
