import 'dart:typed_data';

import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/invoice_data.dart';

/// Builds the allocation invoice as a PDF and shares it, so the courier
/// can send it or save it to the phone.
class InvoicePdf {
  InvoicePdf._();

  static const _dark = PdfColor.fromInt(0xFF444444);
  static const _header = PdfColor.fromInt(0xFFE5DDD5);
  static const _footer = PdfColor.fromInt(0xFFB9B2AA);

  static Future<void> share(InvoiceData data) async {
    try {
      final bytes = await build(data);
      final safeNo = data.invoiceNumber.replaceAll(
        RegExp(r'[^A-Za-z0-9_-]'),
        '',
      );
      final fileName = 'Invoice${safeNo.isEmpty ? '' : '-$safeNo'}.pdf';
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes, mimeType: 'application/pdf', name: fileName),
          ],
          fileNameOverrides: [fileName],
          subject: 'Invoice ${data.invoiceNumber}',
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not create the invoice PDF. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  static Future<Uint8List> build(InvoiceData data) async {
    final doc = pw.Document();
    final label = pw.TextStyle(color: PdfColors.grey600, fontSize: 10);
    final value = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12);
    final cell = const pw.TextStyle(fontSize: 10);
    final headCell = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 2,
                    color: _dark,
                  ),
                ),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 20),
                    child: pw.Divider(thickness: 1, color: PdfColors.grey400),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Invoice No:', style: label),
                    pw.Text('#${data.invoiceNumber}', style: value),
                    pw.SizedBox(height: 12),
                    pw.Text('Date issued:', style: label),
                    pw.Text(data.formattedDate, style: value),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Issued to:', style: label),
                    pw.Text(data.issuedToName, style: value),
                    pw.Text(
                      data.issuedToRole,
                      style: pw.TextStyle(
                        color: PdfColors.grey700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: const {
                0: pw.FixedColumnWidth(40),
                1: pw.FlexColumnWidth(),
                2: pw.FixedColumnWidth(60),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: _header),
                  children: [
                    _pad(pw.Text('NO', style: headCell)),
                    _pad(pw.Text('DESCRIPTION', style: headCell)),
                    _pad(
                      pw.Text(
                        'QTY',
                        style: headCell,
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < data.lines.length; i++)
                  pw.TableRow(
                    children: [
                      _pad(pw.Text('${i + 1}', style: cell)),
                      _pad(
                        pw.Text(
                          data.lines[i].description,
                          style: cell.copyWith(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      _pad(
                        pw.Text(
                          '${data.lines[i].quantity}',
                          style: cell,
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: _footer),
                  children: [
                    pw.SizedBox(),
                    _pad(
                      pw.Text(
                        'TOTAL DEVICES',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    _pad(
                      pw.Text(
                        '${data.totalQuantity}',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (data.allocatedBy.isNotEmpty) ...[
              pw.SizedBox(height: 30),
              pw.Text('Allocated by:', style: label),
              pw.Text(data.allocatedBy, style: value),
            ],
          ],
        ),
      ),
    );
    return doc.save();
  }

  static pw.Widget _pad(pw.Widget child) =>
      pw.Padding(padding: const pw.EdgeInsets.all(8), child: child);
}
