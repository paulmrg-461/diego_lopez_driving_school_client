import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';

class GetAttendanceReportByLicensePlate {
  final AttendanceReportRepository repository;

  GetAttendanceReportByLicensePlate(this.repository);

  Future<AttendanceReportModel?> call(String licensePlate) async {
    return await repository.getAttendanceReportByLicensePlate(licensePlate);
  }
}
