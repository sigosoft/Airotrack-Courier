import '../controllers/home_controller.dart';
import 'courier_requests_response.dart';

/// One line on the allocation invoice.
class InvoiceLine {
  final String description;
  final int quantity;

  const InvoiceLine(this.description, this.quantity);
}

/// What the invoice shows for one allocation. Built from the courier
/// request and the counts that were allocated, at the moment the
/// allocation succeeds (the backend sends no invoice of its own).
class InvoiceData {
  final String invoiceNumber;
  final DateTime date;
  final String issuedToRole;
  final String issuedToName;
  final String allocatedBy;
  final List<InvoiceLine> lines;

  const InvoiceData({
    required this.invoiceNumber,
    required this.date,
    required this.issuedToRole,
    required this.issuedToName,
    required this.allocatedBy,
    required this.lines,
  });

  int get totalQuantity => lines.fold(0, (sum, l) => sum + l.quantity);

  /// GPS allocation: [newCount] new and [repairedCount] repaired devices.
  factory InvoiceData.gps(
    HomeController home, {
    required int newCount,
    required int repairedCount,
  }) {
    return InvoiceData._fromHome(home, [
      if (newCount > 0) InvoiceLine('GPS device (new)', newCount),
      if (repairedCount > 0) InvoiceLine('GPS device (service)', repairedCount),
    ]);
  }

  /// Camera / speed governor allocation, using the counts the allocation
  /// preview screen showed.
  factory InvoiceData.cameraSpeedGovernor(HomeController home) {
    return InvoiceData._fromHome(home, [
      if (home.newCameraCount.value > 0)
        InvoiceLine('Camera (new)', home.newCameraCount.value),
      if (home.repairedCameraCount.value > 0)
        InvoiceLine('Camera (service)', home.repairedCameraCount.value),
      if (home.newSpeedGovernorCount.value > 0)
        InvoiceLine('Speed governor (new)', home.newSpeedGovernorCount.value),
      if (home.repairedSpeedGovernorCount.value > 0)
        InvoiceLine(
          'Speed governor (service)',
          home.repairedSpeedGovernorCount.value,
        ),
    ]);
  }

  factory InvoiceData._fromHome(HomeController home, List<InvoiceLine> lines) {
    final CourierRequest? req = home.selectedCourierRequest.value;

    final backendNumber = req?.invoiceNumber?.trim() ?? '';
    final reqId = req?.id ?? req?.courierId;
    final String number;
    if (backendNumber.isNotEmpty && backendNumber != 'null') {
      number = backendNumber;
    } else if (reqId != null) {
      number = 'AT-$reqId';
    } else {
      number = '-';
    }

    final int roleType = req?.courierUserType ?? home.resolvedUserType;
    final String role = switch (roleType) {
      1 => 'Dealer',
      2 => 'Technician',
      _ => 'Customer',
    };

    String name = req?.courierUserName?.trim() ?? '';
    if (name.isEmpty) name = home.selectedDealerName.value.trim();

    return InvoiceData(
      invoiceNumber: number,
      date: DateTime.now(),
      issuedToRole: role,
      issuedToName: name.isEmpty ? '-' : name,
      allocatedBy: home.userProfile.value.name.trim(),
      lines: lines,
    );
  }

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
}
