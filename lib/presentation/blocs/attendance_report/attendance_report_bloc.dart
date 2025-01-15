import 'dart:typed_data';

import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_reports_by_owner_id.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/create_attendance_report.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_reports.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_report_by_license_plate.dart';

part 'attendance_report_event.dart';
part 'attendance_report_state.dart';

class AttendanceReportBloc
    extends Bloc<AttendanceReportEvent, AttendanceReportState> {
  final CreateAttendanceReport? createAttendanceReportUseCase;
  final GetAttendanceReportsByDateRange? getAttendanceReportsByDateRange;
  final GetAttendanceReportByLicensePlate? getAttendanceReportByLicensePlate;
  final GetAttendanceReportsByOwnerId? getAttendanceReportsByOwnerId;

  AttendanceReportBloc({
    this.createAttendanceReportUseCase,
    this.getAttendanceReportsByDateRange,
    this.getAttendanceReportByLicensePlate,
    this.getAttendanceReportsByOwnerId,
  }) : super(AttendanceReportInitial()) {
    if (createAttendanceReportUseCase != null) {
      on<CreateAttendanceReportEvent>(_onCreateAttendanceReport);
    }
    if (getAttendanceReportsByDateRange != null) {
      on<GetAttendanceReportsByDateRangeEvent>(
        _onGetAttendanceReportsByDateRangeEvent,
      );
    }
    if (getAttendanceReportByLicensePlate != null) {
      on<CheckLicensePlateEvent>(_onCheckLicensePlateEvent);
    }
    if (getAttendanceReportsByOwnerId != null) {
      on<GetAttendanceReportsByOwnerIdEvent>(
          _onGetAttendanceReportsByOwnerIdEvent);
    }
  }

  Future<void> _onCreateAttendanceReport(
    CreateAttendanceReportEvent event,
    Emitter<AttendanceReportState> emit,
  ) async {
    emit(AttendanceReportLoading());
    try {
      await createAttendanceReportUseCase!(event.report);

      final DateTime now = DateTime.now();

      final List<AttendanceReportModel> reports =
          await getAttendanceReportsByDateRange!(
        DateTime(now.year, now.month, now.day, 0, 0, 0),
        DateTime(now.year, now.month, now.day, 23, 59, 59),
      );

      emit(AttendanceReportSuccess(reports));
    } catch (e) {
      emit(
        AttendanceReportFailure(
          'Failed to create attendance report: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetAttendanceReportsByDateRangeEvent(
    GetAttendanceReportsByDateRangeEvent event,
    Emitter<AttendanceReportState> emit,
  ) async {
    emit(AttendanceReportLoading());
    try {
      final reports = await getAttendanceReportsByDateRange!(
        event.startDate,
        event.endDate,
      );
      emit(AttendanceReportSuccess(reports));
    } catch (e) {
      emit(
        AttendanceReportFailure(
            'Error al cargar los reportes: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCheckLicensePlateEvent(
    CheckLicensePlateEvent event,
    Emitter<AttendanceReportState> emit,
  ) async {
    try {
      final report = await getAttendanceReportByLicensePlate!.call(
        event.licensePlate,
      );
      if (report != null) {
        // Verificar si el reporte actual es diferente al anterior para evitar emisiones duplicadas
        if (state is! AttendanceReportPreFillState ||
            (state as AttendanceReportPreFillState).report != report) {
          emit(AttendanceReportPreFillState(report));
        }
      } else {
        emit(AttendanceReportInitial());
      }
    } catch (e) {
      emit(
        AttendanceReportFailure(
          'Error al buscar el reporte de vehículo: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onGetAttendanceReportsByOwnerIdEvent(
    GetAttendanceReportsByOwnerIdEvent event,
    Emitter<AttendanceReportState> emit,
  ) async {
    emit(AttendanceReportLoading());
    try {
      final reports = await getAttendanceReportsByOwnerId!(event.ownerId);
      emit(AttendanceReportOwnerReportsSuccess(reports));
    } catch (e) {
      emit(
        AttendanceReportFailure(
          'Error al buscar reportes por cédula: ${e.toString()}',
        ),
      );
    }
  }
}
