import 'dart:typed_data';

import 'package:diego_lopez_driving_school_client/data/datasources/firebase_storage_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/attendance_report_data_source.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';
import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';

class AttendanceReportRepositoryImpl implements AttendanceReportRepository {
  final AttendanceReportDataSource dataSource;

  final FirebaseStorageDataSource storageDataSource;

  AttendanceReportRepositoryImpl({
    required this.dataSource,
    required this.storageDataSource,
  });

  @override
  Future<void> createAttendanceReport(AttendanceReport report) async {
    try {
      final attendanceReportModel = AttendanceReportModel(
        licensePlate: report.licensePlate,
        mileage: report.mileage,
        brand: report.brand,
        color: report.color,
        serviceType: report.serviceType,
        observations: report.observations,
        name: report.name,
        lastname: report.lastname,
        phone: report.phone,
        documentType: report.documentType,
        documentNumber: report.documentNumber,
        email: report.email,
        address: report.address,
        createdAt: report.createdAt,
        inviteEvents: report.inviteEvents,
        shareContact: report.shareContact,
        sendNews: report.sendNews,
        manageRequests: report.manageRequests,
        conductSurveys: report.conductSurveys,
        reminderRTMyEC: report.reminderRTMyEC,
        signatureUrl: report.signatureUrl,
        attendanceStateImageUrl: report.attendanceStateImageUrl,
        year: report.year,
        isSecondVisit: report.isSecondVisit,
        frontPressure: report.frontPressure,
        rearPressure: report.rearPressure,
        operatorUsername: report.operatorUsername,
        hasAttendanceOwnershipCard: report.hasAttendanceOwnershipCard,
        hasSoat: report.hasSoat,
        isTeachingAttendance: report.isTeachingAttendance,
        isDischarged: report.isDischarged,
        isAlarmDeactivated: report.isAlarmDeactivated,
        hasCenterSupport: report.hasCenterSupport,
        obstacleToCheckingBrakeFluid: report.obstacleToCheckingBrakeFluid,
        passengersQuantity: report.passengersQuantity,
        isAttendanceClean: report.isAttendanceClean,
        hasCups: report.hasCups,
        hasTroubleEntering: report.hasTroubleEntering,
        hasFuel: report.hasFuel,
      );

      await dataSource.createAttendanceReport(attendanceReportModel.toMap());
    } catch (e) {
      throw Exception('Error al crear el reporte de vehículo: ${e.toString()}');
    }
  }

  @override
  Future<List<AttendanceReportModel>> getAttendanceReportsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final documentSnapshots =
          await dataSource.getAttendanceReportsByDateRange(
        startDate,
        endDate,
      );
      return documentSnapshots
          .map((doc) => AttendanceReportModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception(
        'Error al obtener los reportes de vehículos: ${e.toString()}',
      );
    }
  }

  @override
  Future<AttendanceReportModel?> getAttendanceReportByLicensePlate(
    String licensePlate,
  ) async {
    final reportData = await dataSource.getAttendanceReportByLicensePlate(
      licensePlate,
    );
    return reportData != null
        ? AttendanceReportModel.fromSnapshot(reportData)
        : null;
  }

  @override
  Future<List<AttendanceReportModel>> getAttendanceReportsByOwnerId(
    String ownerId,
  ) async {
    try {
      final documentSnapshots = await dataSource.getAttendanceReportsByOwnerId(
        ownerId,
      );
      return documentSnapshots
          .map((doc) => AttendanceReportModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception(
        'Error al obtener los reportes de vehículos por cédula: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> uploadFile({
    required String folderName,
    required String fileName,
    required Uint8List fileBytes,
  }) {
    return storageDataSource.uploadFile(
      folderName: folderName,
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
