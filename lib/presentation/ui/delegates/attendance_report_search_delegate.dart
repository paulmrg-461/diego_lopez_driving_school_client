import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_report_by_license_plate.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/attendance_report_card.dart';
import 'package:flutter/material.dart';

class AttendanceReportSearchDelegate
    extends SearchDelegate<AttendanceReportModel?> {
  final GetAttendanceReportByLicensePlate getAttendanceReportByLicensePlate;

  AttendanceReportSearchDelegate(
      {required this.getAttendanceReportByLicensePlate})
      : super(
          searchFieldLabel: 'Buscar por Placa',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          tooltip: 'Limpiar búsqueda',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
      tooltip: 'Volver',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Ingresa una placa para buscar'));
    }

    return FutureBuilder<AttendanceReportModel?>(
      future:
          getAttendanceReportByLicensePlate.call((query.toUpperCase()).trim()),
      builder: (
        BuildContext context,
        AsyncSnapshot<AttendanceReportModel?> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final report = snapshot.data;
          if (report == null) {
            return const Center(
              child: Text('No se encontró ningún reporte para esta placa.'),
            );
          }
          return Column(children: [AttendanceReportCard(report: report)]);
        } else {
          return const Center(child: Text('No se encontró ningún reporte.'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
