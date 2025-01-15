// history_reports_tab.dart

import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart'; // Para crear el ZIP
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/attendance_report/attendance_report_bloc.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/attendance_report_card.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/pdf_generator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:archive/archive_io.dart'; // Solo para no-Web
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
// Importar 'dart:html' solo para Web
import 'dart:html' as html;

class HistoryReportsTab extends StatefulWidget {
  const HistoryReportsTab({super.key});

  @override
  _HistoryReportsTabState createState() => _HistoryReportsTabState();
}

class _HistoryReportsTabState extends State<HistoryReportsTab> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  bool _isGenerating = false; // Para mostrar un indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  // Método para obtener los reportes según el rango de fechas seleccionado
  void _fetchReports() {
    final DateTime startDate = DateTime(
      _selectedDateRange.start.year,
      _selectedDateRange.start.month,
      _selectedDateRange.start.day,
      0,
      0,
      0,
    );
    final DateTime endDate = DateTime(
      _selectedDateRange.end.year,
      _selectedDateRange.end.month,
      _selectedDateRange.end.day,
      23,
      59,
      59,
      999,
    );

    context.read<AttendanceReportBloc>().add(
          GetAttendanceReportsByDateRangeEvent(
              startDate: startDate, endDate: endDate),
        );
  }

  // Método para manejar el refresco (Pull to Refresh)
  Future<void> _handleRefresh() async {
    _fetchReports();
  }

  // Método para generar y descargar el archivo ZIP
  Future<void> _generateAndDownloadZip(List<AttendanceReport> reports) async {
    List<AttendanceReport> filteredReports = reports.where((report) {
      return report.engineerUsername != null &&
          report.engineerUsername!.isNotEmpty;
    }).toList();

    setState(() {
      _isGenerating = true;
    });

    try {
      if (kIsWeb) {
        await _generateZipForWeb(filteredReports);
      } else {
        await _generateZipForMobileDesktop(filteredReports);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Archivo ZIP generado y descargado exitosamente'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al generar el ZIP: $e')));
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // Función para generar ZIP en Web

  Future<void> _generateZipForWeb(List<AttendanceReport> reports) async {
    // Crear un objeto Archive
    final archive = Archive();

    for (var report in reports) {
      final pdfBytes = await generatePdfBytes(report);
      final fileName =
          'RTE_${report.licensePlate}_${_convertDate(report.createdAt)}.pdf';
      archive.addFile(ArchiveFile(fileName, pdfBytes.length, pdfBytes));
    }

    // Codificar el ZIP
    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive)!;

    // Crear un Blob a partir del ZIP
    final blob = html.Blob([zipData], 'application/zip');

    // Crear una URL para el Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear un enlace y simular el click para descargar
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
        'download',
        'Reports_${_convertDate(_selectedDateRange.start)}_${_convertDate(_selectedDateRange.end)}.zip',
      )
      ..click();

    // Liberar la URL
    html.Url.revokeObjectUrl(url);
  }

  // Función para generar ZIP en Mobile/Desktop
  Future<void> _generateZipForMobileDesktop(
      List<AttendanceReport> reports) async {
    // Solicitar permisos de almacenamiento
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Permiso de almacenamiento denegado');
      }
    }

    // Crear un directorio temporal para almacenar los PDFs
    final tempDir = await getTemporaryDirectory();
    final pdfDir = Directory('${tempDir.path}/pdfs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    // Generar y guardar los PDFs
    for (var report in reports) {
      final pdfBytes = await generatePdfBytes(report);
      final fileName =
          'RTE_${report.licensePlate}_${_convertDate(report.createdAt)}.pdf';
      final file = File('${pdfDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
    }

    // Comprimir los PDFs en un archivo ZIP
    final zipEncoder = ZipFileEncoder();
    final zipFilePath =
        '${tempDir.path}/Reports_${_convertDate(_selectedDateRange.start)}_${_convertDate(_selectedDateRange.end)}.zip';
    zipEncoder.create(zipFilePath);
    zipEncoder.addDirectory(pdfDir, includeDirName: false);
    zipEncoder.close();

    // Compartir o guardar el archivo ZIP usando Share.shareXFiles
    await Share.shareXFiles([
      XFile(zipFilePath),
    ], text: 'Aquí están los reportes generados.');

    // Limpiar archivos temporales
    await pdfDir.delete(recursive: true);
    final zipFile = File(zipFilePath);
    if (await zipFile.exists()) {
      await zipFile.delete();
    }
  }

  // Método auxiliar para convertir la fecha
  String _convertDate(DateTime date) {
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceReportBloc, AttendanceReportState>(
      builder: (context, state) {
        if (state is AttendanceReportLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is AttendanceReportSuccess) {
          if (state.reports.isEmpty) {
            return const Center(child: Text('No se encontraron reportes'));
          }
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Asegura que el RefreshIndicator siempre sea desplegable
                  itemCount: state.reports.length,
                  itemBuilder: (context, index) {
                    final report = state.reports[index];
                    return AttendanceReportCard(report: report);
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: _isGenerating
                      ? null
                      : () {
                          _generateAndDownloadZip(state.reports);
                        },
                  label: const Text('Descargar Todos'),
                  icon: const Icon(Icons.download),
                ),
              ),
              if (_isGenerating)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        } else if (state is AttendanceReportFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(
            child: Text('Ha ocurrido un error al cargar reportes'),
          );
        }
      },
    );
  }
}
