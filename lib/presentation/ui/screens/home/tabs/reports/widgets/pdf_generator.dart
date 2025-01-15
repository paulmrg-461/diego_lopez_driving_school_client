import 'package:diego_lopez_driving_school_client/config/global/environment.dart';
import 'package:diego_lopez_driving_school_client/core/helpers/human_formats.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/conditions_rte.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/personal_data_processing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Función auxiliar para convertir la fecha
String _convertDate(DateTime date) {
  return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}

pw.Widget buildConditionItem(int conditionId, String conditionText) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 1.2),
    child: pw.Text(
      '$conditionId. $conditionText',
      style: const pw.TextStyle(
        fontSize: 8, // Ajusta según tus necesidades
      ),
    ),
  );
}

/// Función para construir el documento PDF
Future<pw.Document> buildPdfDocument(AttendanceReport report) async {
  final pdf = pw.Document(
    title: 'RTE_${report.licensePlate}_${_convertDate(report.createdAt)}.pdf',
    author: 'DevPaul',
  );

  // Función para cargar imágenes desde URLs
  Future<pw.ImageProvider?> loadImageFromUrl(String imageUrl) async {
    try {
      final image = await networkImage(imageUrl);
      return image;
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return null;
    }
  }

  // Cargar imágenes desde assets
  final logoSuperTransporte = pw.MemoryImage(
    (await rootBundle.load('assets/supertransporte.png')).buffer.asUint8List(),
  );
  final logoCda = pw.MemoryImage(
    (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
  );

  // Cargar imágenes desde URLs si están disponibles
  final pw.ImageProvider? attendanceImage =
      report.attendanceStateImageUrl != null
          ? await loadImageFromUrl(report.attendanceStateImageUrl!)
          : null;

  // Cargar firmas
  final recepcionistImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${Environment.receptionist}@diegolopez.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc';
  final recepcionistSignatureImage = await loadImageFromUrl(
    recepcionistImageUrl,
  );

  final engineerImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${report.engineerUsername}@diegolopez.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc';
  final engineerImage = await loadImageFromUrl(engineerImageUrl);

  final signatureImage = report.signatureUrl != null
      ? await loadImageFromUrl(report.signatureUrl!)
      : null;

  // Ordenar condiciones
  final sortedConditions = conditions.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  final first23Conditions = sortedConditions.take(23).toList();
  final remainingConditions = sortedConditions.skip(23).toList();

  // Añadir contenido al PDF
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (pw.Context context) {
        return getPwHeader(
          logoSuperTransporte: logoSuperTransporte,
          logoCda: logoCda,
          context: context,
        );
      },
      build: (pw.Context context) {
        final String isSecondVisit = report.isSecondVisit ?? false ? '2' : '1';
        return [
          getPwContent(
            context: context,
            engineerImage: engineerImage!,
            first23Conditions: first23Conditions,
            remainingConditions: remainingConditions,
            isSecondVisit: isSecondVisit,
            recepcionistSignatureImage: recepcionistSignatureImage!,
            attendanceImage: attendanceImage!,
            report: report,
            signatureImage: signatureImage!,
          ),
        ];
      },
    ),
  );

  return pdf;
}

/// Función existente para generar y mostrar el PDF individual
Future<void> generatePdf(AttendanceReport report) async {
  final pdf = await buildPdfDocument(report);

  // Guardar o imprimir el PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

/// Nueva función para obtener los bytes del PDF
Future<List<int>> generatePdfBytes(AttendanceReport report) async {
  final pdf = await buildPdfDocument(report);
  return pdf.save(); // Retorna los bytes del PDF
}

pw.Container getPwHeader({
  required pw.MemoryImage logoSuperTransporte,
  required pw.MemoryImage logoCda,
  required pw.Context context,
}) =>
    pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      margin: const pw.EdgeInsets.only(bottom: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Columna de Textos
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'ORDEN DE SERVICIO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('F-036', style: const pw.TextStyle(fontSize: 8)),
                      pw.Text(
                        'REVISIÓN TÉCNICO MECÁNICA Y DE EMISIONES CONTAMINANTES',
                        style: const pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(width: 4),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Página ${context.pageNumber} de ${context.pagesCount}',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Versión ',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Fecha de Emisión: ',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                child: pw.Image(logoSuperTransporte, width: 60, height: 60),
              ),
              pw.Image(logoCda, width: 40, height: 40),
            ],
          ),
        ],
      ),
    );

pw.Container getPwContent({
  required AttendanceReport report,
  required String isSecondVisit,
  required pw.ImageProvider signatureImage,
  required pw.ImageProvider engineerImage,
  required pw.ImageProvider attendanceImage,
  required pw.ImageProvider recepcionistSignatureImage,
  required List<MapEntry<int, String>> first23Conditions,
  required List<MapEntry<int, String>> remainingConditions,
  required pw.Context context,
}) =>
    pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1.2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Fecha: ${HumanFormats.convertDate(report.createdAt)}   ${HumanFormats.convertTime(report.createdAt)}',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Visita: #$isSecondVisit',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Placa: ${report.licensePlate}',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Kilometraje: ${report.mileage}',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey600, width: 1.2),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // Primera Fila de Textos
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Marca: ${report.brand}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Servicio: ${report.serviceType}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Color: ${report.color}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Contenedor con Borde Simétrico
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border.symmetric(
                            horizontal: pw.BorderSide(
                              color: PdfColors.grey600,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Licencia de tránsito: ${report.hasAttendanceOwnershipCard ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                'SOAT: ${report.hasSoat ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                'Pasajeros: ${report.passengersQuantity ?? 1}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                'Enseñanza: ${report.isTeachingAttendance ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border.symmetric(
                            horizontal: pw.BorderSide(
                              color: PdfColors.grey600,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Vehículo Limpio: ${report.isAttendanceClean ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                'Copas: ${report.hasCups ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                'Condición que impida ingreso: ${report.hasTroubleEntering ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Vehículo Descargado: ${report.isDischarged ?? false ? 'SI' : 'NO'}',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                            pw.SizedBox(width: 52),
                            pw.Text(
                              'Combustible suficiente: ${report.hasFuel ?? false ? 'SI' : 'NO'}',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border.symmetric(
                            horizontal: pw.BorderSide(
                              color: PdfColors.grey600,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Alarma desactivada: ${report.isAlarmDeactivated ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.SizedBox(width: 61),
                              pw.Text(
                                'Soporte Central: ${report.hasCenterSupport ?? false ? 'SI' : 'NO'}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 4, left: 4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Obstáculo para revisar nivel líquido de frenos:',
                                  style: const pw.TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                            pw.Text(
                              report.obstacleToCheckingBrakeFluid ?? 'NO',
                              style: const pw.TextStyle(
                                fontSize:
                                    9, // Ajusta el tamaño según tus necesidades
                              ),
                            ),
                            pw.SizedBox(height: 2),
                          ],
                        ),
                      ),
                      // Continuar con los demás elementos siguiendo el mismo patrón...
                    ],
                  ),
                ),
              ),
              // Columna Derecha
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey600, width: 1.2),
                ),
                child: pw.Column(
                  children: [
                    if (attendanceImage != null)
                      pw.Image(attendanceImage, height: 60),
                    pw.Text(
                      'Presión Llantas (PSI): D: ${report.frontPressure} - T: ${report.rearPressure}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.only(right: 4, left: 4),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Observaciones:',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
                pw.Text(
                  report.observations,
                  style: const pw.TextStyle(
                    fontSize: 9, // Ajusta el tamaño según tus necesidades
                  ),
                ),
                pw.SizedBox(height: 2),
              ],
            ),
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Responsable de la recepción:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (recepcionistSignatureImage != null)
                        pw.Image(recepcionistSignatureImage, height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(left: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      'Vehículo preparado para ser inspeccionado:',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 26, right: 17),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.green200,
                      border: pw.Border.symmetric(
                        vertical: pw.BorderSide(
                          color: PdfColors.grey600,
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Text('SI', style: const pw.TextStyle(fontSize: 10)),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 4),
                          child: pw.Text(
                            'X', // Unicode del ícono de marca de verificación
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border.symmetric(
                        vertical: pw.BorderSide(
                          color: PdfColors.grey600,
                          width: 1.2,
                        ),
                      ),
                    ),
                    child:
                        pw.Text('NO', style: const pw.TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
          pw.Container(
            color: PdfColors.grey200,
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Center(
                child: pw.Text(
                  'Condiciones contractuales para la prestación del Servicio de Revisión Técnico Mecánica y de Emisiones Contaminantes',
                  style:
                      pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Text(
                conditions[0] ?? '',
                style: const pw.TextStyle(
                  fontSize: 8, // Ajusta el tamaño según tus necesidades
                ),
              ),
            ),
          ),
          // Primer Grupo de Condiciones (1-19)
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: first23Conditions.map((entry) {
                  final conditionId = entry.key;
                  final conditionText = entry.value ?? '';
                  if (conditionId == 0) {
                    return pw.SizedBox();
                  }
                  return buildConditionItem(conditionId, conditionText);
                }).toList(),
              ),
            ),
          ),

          // Salto de Página
          pw.NewPage(),

          // Segundo Grupo de Condiciones (20-42)
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: remainingConditions.map((entry) {
                  final conditionId = entry.key;
                  final conditionText = entry.value ?? '';
                  return buildConditionItem(conditionId, conditionText);
                }).toList(),
              ),
            ),
          ),

          // Segundo Fragmento: Condiciones Contractuales
          pw.Container(
            color: PdfColors.grey200,
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Condiciones contractuales para la prestación del Servicio de Revisión Técnico Mecánica y de Emisiones Contaminantes',
                    style: pw.TextStyle(
                      fontSize: 9, // Ajusta según tus necesidades
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Migración del tercer fragmento: Texto descriptivo
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4),
            child: pw.Text(
              'CDA PANAMERICANA SAS, será la responsable del Tratamiento de los datos personales que se registren en este documento y, en tal virtud, los podrá Recolectar, Almacenar, Usar y Circular para las siguientes finalidades:',
              style: const pw.TextStyle(
                fontSize: 9, // Ajusta según tus necesidades
              ),
            ),
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(color: PdfColors.grey600, width: 1.2),
              ),
            ),
            child: pw.Column(
              children: [
                // Encabezado de la tabla
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                    border: pw.Border(
                      bottom:
                          pw.BorderSide(color: PdfColors.grey600, width: 1.2),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'FINALIDAD',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        'AUTORIZA',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                // Filas de condiciones
                ...dataProcessingPurposesList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String purpose = entry.value;
                  bool switchValue = false;

                  // Asignar el valor de autorización según el índice
                  switch (index) {
                    case 0:
                      switchValue = report.inviteEvents;
                      break;
                    case 1:
                      switchValue = report.shareContact;
                      break;
                    case 2:
                      switchValue = report.sendNews;
                      break;
                    case 3:
                      switchValue = report.manageRequests;
                      break;
                    case 4:
                      switchValue = report.conductSurveys;
                      break;
                    case 5:
                      switchValue = report.reminderRTMyEC;
                      break;
                    default:
                      switchValue = false;
                  }

                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom:
                            pw.BorderSide(color: PdfColors.grey600, width: 1.2),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        // Finalidad
                        pw.Container(
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              right: pw.BorderSide(
                                color: PdfColors.grey600,
                                width: 1.2,
                              ),
                            ),
                          ),
                          width: PdfPageFormat.a4.availableWidth *
                              0.96, // Aproximadamente 70% del ancho disponible
                          padding: const pw.EdgeInsets.symmetric(vertical: 3),
                          child: pw.Text(
                            purpose,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ),
                        // Autorización
                        pw.Expanded(
                          child: pw.Text(
                            switchValue ? 'SI' : 'NO',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              ...dataProcessingRights.asMap().entries.map((entry) {
                final String value = entry.value;
                final int key = entry.key;

                if (key != 0) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 4,
                    ),
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: const pw.TextStyle(
                          fontSize: 9,
                        ), // Equivalente a labelSmall
                        children: [
                          pw.TextSpan(
                            text: value.substring(0, 2), // "a. "
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(
                            text: value.substring(2), // Texto después de "a. "
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // key == 0, renderizar el encabezado
                  return pw.Container(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200, // Equivalente a Colors.black12
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey400,
                          width: 1.2,
                        ), // Equivalente a BorderSide(color: Colors.black45, width: 1.2)
                      ),
                    ),
                    padding: const pw.EdgeInsets.symmetric(vertical: 1),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          value,
                          style: pw.TextStyle(
                            fontSize: 10, // Equivalente a labelMedium
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),

              // Contenedor con el texto final
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                decoration: const pw.BoxDecoration(
                  border: pw.Border.symmetric(
                    horizontal: pw.BorderSide(
                      color: PdfColors.grey400,
                      width: 1.2,
                    ), // Equivalente a BorderSide(color: Colors.black45, width: 1.2)
                  ),
                ),
                child: pw.Text(
                  'Teniendo en cuenta todo lo descrito en este documento, como TITULAR de los datos personales otorga consentimiento al CDA PANAMERICANA SAS, para que trate la información personal de acuerdo con la Política de Tratamiento de Datos Personales presentada en documento físico localizado en la sala de espera del CDA PANAMERICANA SAS, localizado en la transversal 9 Nº 6 Norte - 35 Popayán y se da a conocer antes de recolectar los datos en este documento.',
                  style: const pw.TextStyle(
                    fontSize: 9,
                  ), // Equivalente a labelSmall
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Primer Container con fondo gris claro y texto centrado en negrita
              pw.Container(
                color: PdfColors.grey200, // Equivalente a Colors.black12
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'DATOS DEL TITULAR DE LOS DATOS PERSONALES',
                        style: pw.TextStyle(
                          fontSize: 9, // Equivalente a labelSmall
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Segundo Container con borde horizontal y dos textos en negrita
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border.symmetric(
                    horizontal: pw.BorderSide(
                      color: PdfColors.grey400,
                      width: 1.2,
                    ), // Equivalente a BorderSide(color: Colors.black45, width: 1.2)
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Nombres y Apellidos: ${report.name} ${report.lastname}',
                        style: pw.TextStyle(
                          fontSize: 10, // Equivalente a titleSmall
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Celular/Teléfono: ${report.phone}',
                        style: pw.TextStyle(
                          fontSize: 10, // Equivalente a titleSmall
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tercer Padding con dos textos en negrita
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Correo electrónico: ${report.email}',
                      style: pw.TextStyle(
                        fontSize: 10, // Equivalente a titleSmall
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Dirección: ${report.address}',
                      style: pw.TextStyle(
                        fontSize: 10, // Equivalente a titleSmall
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border.symmetric(
                horizontal: pw.BorderSide(
                  color: PdfColors.grey400,
                  width: 1.2,
                ), // Equivalente a Colors.black45
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Primer Texto con ancho 34% del disponible
                  pw.Container(
                    width: PdfPageFormat.a4.availableWidth * 0.39,
                    child: pw.Text(
                      'Acepto los lineamientos y condiciones contractuales relacionados en el presente documento y manifiesto que la presente autorización me fue solicitada antes de entregar mis datos y la suscribo de forma libre y voluntaria una vez leída en su totalidad al igual que la Política de Tratamiento de Datos Personales.',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 8, // Equivalente a labelSmall
                      ),
                    ),
                  ),
                  // Segundo Container con ancho 61% del disponible
                  pw.Container(
                    width: PdfPageFormat.a4.availableWidth * 0.7,
                    padding: const pw.EdgeInsets.only(left: 4),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        left: pw.BorderSide(
                          color:
                              PdfColors.grey400, // Equivalente a Colors.black45
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Por medio de la presenten declaro:',
                          style: const pw.TextStyle(
                            fontSize: 9, // Equivalente a labelSmall
                          ),
                        ),
                        ...dataClarenseRights.map((value) {
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 1),
                            child: pw.RichText(
                              text: pw.TextSpan(
                                style: const pw.TextStyle(
                                  fontSize: 9, // Equivalente a labelSmall
                                ),
                                children: [
                                  pw.TextSpan(
                                    text: value.substring(0, 2), // "a. "
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.TextSpan(
                                    text: value.substring(
                                      2,
                                    ), // Texto después de "a. "
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Primer Container con borde horizontal
              pw.Container(
                decoration: const pw.BoxDecoration(
                  border: pw.Border.symmetric(
                    horizontal:
                        pw.BorderSide(color: PdfColors.grey400, width: 1.2),
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // Primer Contenedor para "Firma del cliente"
                      pw.Container(
                        width: PdfPageFormat.a4.availableWidth * 0.5,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Firma del cliente',
                              style: pw.TextStyle(
                                fontSize: 10, // Equivalente a titleSmall
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            // Cargar y mostrar la imagen de la firma del cliente
                            if (signatureImage != null)
                              pw.Image(signatureImage, height: 24),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'Cédula: ${report.documentNumber}',
                              style: const pw.TextStyle(
                                fontSize: 10, // Equivalente a titleSmall
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Segundo Contenedor para "Firma de director técnico"
                      pw.Container(
                        width: PdfPageFormat.a4.availableWidth * 0.5,
                        padding: const pw.EdgeInsets.only(left: 4),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            left: pw.BorderSide(
                              color: PdfColors.grey400,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Firma de director técnico',
                              style: pw.TextStyle(
                                fontSize: 10, // Equivalente a titleSmall
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            // Cargar y mostrar la imagen de la firma del director técnico
                            if (engineerImage != null)
                              pw.Image(engineerImage, height: 24),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              '',
                              style: const pw.TextStyle(
                                fontSize: 10, // Equivalente a titleSmall
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              // Texto "Software de CDA PANAMERICANA SAS © 2024 Todos los derechos reservados"
              pw.Text(
                'Software de CDA PANAMERICANA SAS © 2024 Todos los derechos reservados',
                style: const pw.TextStyle(
                  fontSize: 9, // Equivalente a labelSmall
                ),
              ),
              pw.SizedBox(height: 5),
              // Texto "Desarrollado por: DevPaul"
              pw.Text(
                'Desarrollado por: DevPaul',
                style: const pw.TextStyle(
                  fontSize: 9, // Equivalente a labelSmall
                ),
              ),
            ],
          ),
          // ... continúa con más contenido migrado ...
        ],
      ),
    );
