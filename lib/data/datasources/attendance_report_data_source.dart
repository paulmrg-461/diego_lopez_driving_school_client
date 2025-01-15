import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AttendanceReportDataSource {
  Future<void> createAttendanceReport(Map<String, dynamic> reportData);
  Future<List<DocumentSnapshot>> getAttendanceReportsByDateRange(
      DateTime startDate, DateTime endDate);
  Future<DocumentSnapshot?> getAttendanceReportByLicensePlate(
      String licensePlate);

  Future<List<DocumentSnapshot>> getAttendanceReportsByOwnerId(String ownerId);
}

class AttendanceReportDataSourceImpl implements AttendanceReportDataSource {
  final FirebaseFirestore firestore;

  AttendanceReportDataSourceImpl(this.firestore);

  @override
  Future<void> createAttendanceReport(Map<String, dynamic> reportData) async {
    try {
      await firestore.collection('attendance_reports').add(reportData);
    } catch (e) {
      throw Exception(
          'Error al crear el reporte de asistencia: ${e.toString()}');
    }
  }

  @override
  Future<List<DocumentSnapshot>> getAttendanceReportsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('attendance_reports')
          .where('createdAt',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('createdAt', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      throw Exception(
          'Error al obtener los reportes de vehículos: ${e.toString()}');
    }
  }

  @override
  Future<DocumentSnapshot?> getAttendanceReportByLicensePlate(
      String licensePlate) async {
    final querySnapshot = await firestore
        .collection('attendance_reports')
        .where('licensePlate', isEqualTo: licensePlate)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
  }

  @override
  Future<List<DocumentSnapshot>> getAttendanceReportsByOwnerId(
      String ownerId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('attendance_reports')
          .where('documentNumber', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      throw Exception(
          'Error al obtener los reportes de vehículos por cédula: ${e.toString()}');
    }
  }
}
