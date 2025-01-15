import 'dart:typed_data';

import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';

abstract class AttendanceReportRepository {
  Future<void> createAttendanceReport(AttendanceReportModel report);
  Future<List<AttendanceReportModel>> getAttendanceReportsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<AttendanceReportModel?> getAttendanceReportByLicensePlate(
    String licensePlate,
  );
  Future<List<AttendanceReportModel>> getAttendanceReportsByOwnerId(
      String ownerId);
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  });
}
