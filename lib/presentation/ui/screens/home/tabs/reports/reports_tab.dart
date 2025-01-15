import 'package:diego_lopez_driving_school_client/presentation/blocs/attendance_report/attendance_report_bloc.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/attendance_report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  bool _hasLoadedReports = false;

  DateTime _getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  DateTime _getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedReports) {
      final DateTime now = DateTime.now();
      final DateTime startDate = _getStartOfDay(now);
      final DateTime endDate = _getEndOfDay(now);

      // Emitir evento solo una vez
      context.read<AttendanceReportBloc>().add(
            GetAttendanceReportsByDateRangeEvent(
              startDate: startDate,
              endDate: endDate,
            ),
          );
      _hasLoadedReports = true;
    }
  }

  Future<void> _handleRefresh() async {
    final DateTime now = DateTime.now();
    final DateTime startDate = _getStartOfDay(now);
    final DateTime endDate = _getEndOfDay(now);

    context.read<AttendanceReportBloc>().add(
          GetAttendanceReportsByDateRangeEvent(
              startDate: startDate, endDate: endDate),
        );

    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceReportBloc, AttendanceReportState>(
      builder: (context, state) {
        if (state is AttendanceReportSuccess) {
          if (state.reports.isEmpty) {
            return const Center(child: Text('No se encontraron reportes'));
          }
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return AttendanceReportCard(report: report);
              },
            ),
          );
        } else if (state is AttendanceReportFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
