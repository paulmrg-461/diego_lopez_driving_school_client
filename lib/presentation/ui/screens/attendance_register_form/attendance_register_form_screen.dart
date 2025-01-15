import 'dart:async';
import 'dart:ui' as ui;
import 'package:diego_lopez_driving_school_client/core/validators/input_validators.dart';
import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/attendance_report/attendance_report_bloc.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/attendance_register_form/widgets/contractual_conditions.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/attendance_register_form/widgets/attendance_register_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';

class AttendanceRegisterFormScreen extends StatefulWidget {
  static const String name = 'attendance_register_form_screen';
  final String userEmail;

  const AttendanceRegisterFormScreen({super.key, required this.userEmail});

  @override
  _AttendanceRegisterFormScreenState createState() =>
      _AttendanceRegisterFormScreenState();
}

class _AttendanceRegisterFormScreenState
    extends State<AttendanceRegisterFormScreen> {
  static const double _inputsWidth = 238;
  final _formKey = GlobalKey<FormState>();
  bool _hasShownPreFillSnackbar = false;
  Timer? _debounce;

  final GlobalKey _displayRepaintBoundaryKey = GlobalKey();

  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _frontPressureController =
      TextEditingController();
  final TextEditingController _rearPressureController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _passengersController = TextEditingController(
    text: '1',
  );
  final TextEditingController _obstacleToCheckingBrakeFluid =
      TextEditingController();
  String? _brand;
  String? _color;
  String? _serviceType = 'Particular';
  bool _hasAttendanceOwnershipCard = true;
  bool _hasSoat = true;
  bool _isTeachingAttendance = false;
  bool _isDischarged = true;
  bool _isAlarmDeactivated = true;
  bool _hasCenterSupport = true;
  bool _isAttendanceClean = true;
  bool _hasCups = false;
  bool _hasTroubleEntering = false;
  bool _hasFuel = true;
  bool _hasObstacleToCheckingBrakeFluid = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _docNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _docType = 'CC';

  bool _inviteEvents = true;
  bool _shareContact = true;
  bool _sendNews = true;
  bool _manageRequests = true;
  bool _conductSurveys = true;
  bool _reminderRTMyEC = true;
  bool _isSecondVisit = false;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _isSignatureLocked = false;

  void _toggleSignatureLock() {
    setState(() {
      _isSignatureLocked = !_isSignatureLocked;
    });
  }

  final SignatureController _motorcycleController = SignatureController(
    penStrokeWidth: 2.5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
  );

  bool _isMotorcycleSignatureLocked = true;
  void _toggleMotorcycleSignatureLock() {
    setState(() {
      _isMotorcycleSignatureLocked = !_isMotorcycleSignatureLocked;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/motorcycle_bg3.png'), context);
    });

    _licensePlateController.addListener(_onLicensePlateChanged);
  }

  void _onLicensePlateChanged() {
    final text = _licensePlateController.text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      if ((text.length == 5 || text.length == 6) &&
          InputValidator.licensePlateValidator(text) == null) {
        context.read<AttendanceReportBloc>().add(CheckLicensePlateEvent(text));
      }
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _motorcycleController.dispose();
    _licensePlateController.dispose();
    _mileageController.dispose();
    _yearController.dispose();
    _observationsController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _docNumberController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _obstacleToCheckingBrakeFluid.dispose();
    _passengersController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;
    final double screenWidth = isMobile ? size.width : 571;
    // final double screenWidth = isMobile ? size.width : 571;
    final double motorcycleImgHeight = isMobile ? 100 : 170;

    return BlocListener<AttendanceReportBloc, AttendanceReportState>(
      listenWhen: (previous, current) =>
          current is AttendanceReportLoaded ||
          current is AttendanceReportPreFillState ||
          current is AttendanceReportFailure,
      listener: (context, state) {
        if (state is AttendanceReportLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reporte creado con éxito')),
          );
          _resetForm();
        } else if (state is AttendanceReportPreFillState) {
          if (!_hasShownPreFillSnackbar) {
            _hasShownPreFillSnackbar = true;

            final report = state.report;
            _nameController.text = report.name;
            _lastnameController.text = report.lastname;
            _docType = report.documentType;
            _docNumberController.text = report.documentNumber ?? '';
            _phoneController.text = report.phone;
            _addressController.text = report.address;
            _emailController.text = report.email;
            _yearController.text = report.year ?? '';

            setState(() {
              _brand = report.brand;
              _color = report.color;
              _serviceType = report.serviceType;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Los datos para el vehículo ${report.licensePlate} han sido encontrados en la base de datos.',
                ),
              ),
            );
          }
        } else if (state is AttendanceReportFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Registro de vehículo')),
        body: Form(
          key: _formKey,
          child: BlocBuilder<AttendanceReportBloc, AttendanceReportState>(
            builder: (context, state) {
              final bool isLoading = state is AttendanceReportLoading;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: ListView(
                      children: [
                        SwitchListTile(
                          title: Text(
                            'Es segunda visita?',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          value: _isSecondVisit,
                          onChanged: (value) =>
                              setState(() => _isSecondVisit = value),
                        ),
                        AttendanceDataTile(
                          inputsWidth: _inputsWidth,
                          licensePlateController: _licensePlateController,
                          yearController: _yearController,
                          frontPressureController: _frontPressureController,
                          rearPressureController: _rearPressureController,
                          mileageController: _mileageController,
                          brand: _brand,
                          color: _color,
                          serviceType: _serviceType,
                          observationsController: _observationsController,
                          passengersController: _passengersController,
                          obstacleToCheckingBrakeFluid:
                              _obstacleToCheckingBrakeFluid,
                          hasAttendanceOwnershipCard:
                              _hasAttendanceOwnershipCard,
                          hasSoat: _hasSoat,
                          isTeachingAttendance: _isTeachingAttendance,
                          isDischarged: _isDischarged,
                          isAlarmDeactivated: _isAlarmDeactivated,
                          hasCenterSupport: _hasCenterSupport,
                          hasFuel: _hasFuel,
                          isAttendanceClean: _isAttendanceClean,
                          hasCups: _hasCups,
                          hasTroubleEntering: _hasTroubleEntering,
                          hasObstacleToCheckingBrakeFluid:
                              _hasObstacleToCheckingBrakeFluid,
                          onBrandChanged: (value) =>
                              setState(() => _brand = value),
                          onColorChanged: (value) =>
                              setState(() => _color = value),
                          onServiceTypeChanged: (value) =>
                              setState(() => _serviceType = value),
                          onAttendanceOwnershipCardChanged: (value) => setState(
                            () => _hasAttendanceOwnershipCard = value,
                          ),
                          onSoatChanged: (value) =>
                              setState(() => _hasSoat = value),
                          onTeachingAttendanceChanged: (value) =>
                              setState(() => _isTeachingAttendance = value),
                          onDischargedChanged: (value) =>
                              setState(() => _isDischarged = value),
                          onAlarmDeactivatedChanged: (value) =>
                              setState(() => _isAlarmDeactivated = value),
                          onCenterSupportChanged: (value) =>
                              setState(() => _hasCenterSupport = value),
                          onHasFuelChanged: (value) =>
                              setState(() => _hasFuel = value),
                          onHasCupsChanged: (value) =>
                              setState(() => _hasCups = value),
                          onHasTroubleEnteringChanged: (value) =>
                              setState(() => _hasTroubleEntering = value),
                          onAttendanceCleanChanged: (value) =>
                              setState(() => _isAttendanceClean = value),
                          onHasObstacleToCheckingBrakeFluidChanged: (value) =>
                              setState(
                            () => _hasObstacleToCheckingBrakeFluid = value,
                          ),
                        ),
                        _buildMotorcycleStateWidget(
                          screenWidth,
                          motorcycleImgHeight,
                          size.width,
                        ),
                        const Divider(),
                        const ContractualConditions(),
                        ConsentTile(
                          inviteEvents: _inviteEvents,
                          shareContact: _shareContact,
                          sendNews: _sendNews,
                          manageRequests: _manageRequests,
                          conductSurveys: _conductSurveys,
                          reminderRTMyEC: _reminderRTMyEC,
                          onInviteEventsChanged: (value) =>
                              setState(() => _inviteEvents = value),
                          onShareContactChanged: (value) =>
                              setState(() => _shareContact = value),
                          onSendNewsChanged: (value) =>
                              setState(() => _sendNews = value),
                          onManageRequestsChanged: (value) =>
                              setState(() => _manageRequests = value),
                          onConductSurveysChanged: (value) =>
                              setState(() => _conductSurveys = value),
                          onReminderRTMyECChanged: (value) =>
                              setState(() => _reminderRTMyEC = value),
                        ),
                        const Divider(),
                        Text(
                          'Teniendo en cuenta todo lo descrito en este documento, como TITULAR de los datos personales otorga consentimiento al CDA PANAMERICANA SAS, para que trate la información personal de acuerdo con la Política de Tratamiento de Datos Personales presentada en documento físico localizado en la sala de espera del CDA PANAMERICANA SAS, localizado en la transversal 9 Nº 6 Norte - 35 Popayán y se da a conocer antes de recolectar los datos en este documento.',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Divider(),
                        OwnerDataTile(
                          inputsWidth: _inputsWidth,
                          nameController: _nameController,
                          lastnameController: _lastnameController,
                          docNumberController: _docNumberController,
                          phoneController: _phoneController,
                          addressController: _addressController,
                          emailController: _emailController,
                          docType: _docType,
                          signatureController: _signatureController,
                          onDocTypeChanged: (value) =>
                              setState(() => _docType = value),
                          isLocked:
                              _isSignatureLocked, // Pasar el estado de bloqueo
                          onToggleLock: _toggleSignatureLock,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: _resetForm,
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_motorcycleController.isNotEmpty &&
                                      _brand != null &&
                                      _serviceType != null &&
                                      _color != null) {
                                    try {
                                      Uint8List attendanceStateImage;

                                      if (_motorcycleController.isNotEmpty) {
                                        final ui.Image? drawingImage =
                                            await _motorcycleController
                                                .toImage();

                                        if (drawingImage == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error al capturar el estado del vehículo.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final ByteData bgByteData =
                                            await rootBundle.load(
                                          'assets/motorcycle_bg3.png',
                                        );
                                        final Uint8List bgBytes =
                                            bgByteData.buffer.asUint8List();
                                        final ui.Codec bgCodec = await ui
                                            .instantiateImageCodec(bgBytes);
                                        final ui.FrameInfo bgFrame =
                                            await bgCodec.getNextFrame();
                                        final ui.Image bgImage = bgFrame.image;

                                        final ui.Image resizedDrawingImage =
                                            await resizeImage(
                                          drawingImage,
                                          screenWidth.toInt(),
                                          motorcycleImgHeight.toInt(),
                                        );

                                        final ui.PictureRecorder recorder =
                                            ui.PictureRecorder();
                                        final Canvas canvas = Canvas(recorder);

                                        // Definir rectángulos de origen y destino correctamente
                                        Rect dstRect = Rect.fromLTWH(
                                          0,
                                          0,
                                          screenWidth,
                                          motorcycleImgHeight,
                                        );
                                        Rect srcRectBg = Rect.fromLTWH(
                                          0,
                                          0,
                                          bgImage.width.toDouble(),
                                          bgImage.height.toDouble(),
                                        );
                                        Rect srcRectDrawing = Rect.fromLTWH(
                                          0,
                                          0,
                                          resizedDrawingImage.width.toDouble(),
                                          resizedDrawingImage.height.toDouble(),
                                        );

                                        // Dibuja la imagen de fondo
                                        canvas.drawImageRect(
                                          bgImage,
                                          srcRectBg,
                                          dstRect,
                                          Paint(),
                                        );

                                        // Dibuja la imagen de la firma
                                        canvas.drawImageRect(
                                          resizedDrawingImage,
                                          srcRectDrawing,
                                          dstRect,
                                          Paint(),
                                        );

                                        final ui.Image combinedImage =
                                            await recorder
                                                .endRecording()
                                                .toImage(
                                                  screenWidth.toInt(),
                                                  motorcycleImgHeight.toInt(),
                                                );

                                        final ByteData? combinedByteData =
                                            await combinedImage.toByteData(
                                          format: ui.ImageByteFormat.png,
                                        );

                                        if (combinedByteData == null) {
                                          throw Exception(
                                            'No se pudo obtener los bytes de la imagen combinada.',
                                          );
                                        }

                                        attendanceStateImage = combinedByteData
                                            .buffer
                                            .asUint8List();
                                      } else {
                                        final ByteData bgByteData =
                                            await rootBundle.load(
                                          'assets/motorcycle_bg3.png',
                                        );
                                        final Uint8List bgBytes =
                                            bgByteData.buffer.asUint8List();
                                        final ui.Codec bgCodec = await ui
                                            .instantiateImageCodec(bgBytes);
                                        final ui.FrameInfo bgFrame =
                                            await bgCodec.getNextFrame();
                                        final ui.Image bgImage = bgFrame.image;

                                        final ByteData? bgByteDataFinal =
                                            await bgImage.toByteData(
                                          format: ui.ImageByteFormat.png,
                                        );
                                        if (bgByteDataFinal == null) {
                                          throw Exception(
                                            'No se pudo obtener los bytes de la imagen de fondo.',
                                          );
                                        }

                                        attendanceStateImage = bgByteDataFinal
                                            .buffer
                                            .asUint8List();
                                      }

                                      final Uint8List? signature =
                                          await _signatureController
                                              .toPngBytes();

                                      if (signature != null) {
                                        _onSubmit(
                                            signature, attendanceStateImage);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error al capturar la firma.',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al capturar la imagen: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Por favor, firme el formulario y complete los campos requeridos.',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor, complete los campos requeridos.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              label: const Text('Guardar'),
                              icon: const Icon(Icons.save_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSubmit(Uint8List signature, Uint8List attendanceStateImage) async {
    if (_formKey.currentState!.validate()) {
      final attendanceReport = AttendanceReportModel(
        licensePlate: _licensePlateController.text,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        brand: _brand!,
        color: _color!,
        serviceType: _serviceType!,
        passengersQuantity: int.tryParse(_passengersController.text) ?? 1,
        hasAttendanceOwnershipCard: _hasAttendanceOwnershipCard,
        hasSoat: _hasSoat,
        isTeachingAttendance: _isTeachingAttendance,
        isAttendanceClean: _isAttendanceClean,
        hasCups: _hasCups,
        hasFuel: _hasFuel,
        hasTroubleEntering: _hasTroubleEntering,
        isDischarged: _isDischarged,
        isAlarmDeactivated: _isAlarmDeactivated,
        hasCenterSupport: _hasCenterSupport,
        obstacleToCheckingBrakeFluid:
            (_obstacleToCheckingBrakeFluid.text.trim() != '')
                ? _obstacleToCheckingBrakeFluid.text.trim()
                : 'NO',
        observations: _observationsController.text.trim(),
        name: _nameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        documentType: _docType!,
        documentNumber: _docNumberController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        createdAt: DateTime.now(),
        inviteEvents: _inviteEvents,
        shareContact: _shareContact,
        sendNews: _sendNews,
        manageRequests: _manageRequests,
        conductSurveys: _conductSurveys,
        reminderRTMyEC: _reminderRTMyEC,
        isSecondVisit: _isSecondVisit,
        operatorUsername: widget.userEmail.replaceAll(
          '@cdapanamericana.com',
          '',
        ),
        signatureUrl: '',
        attendanceStateImageUrl: '',
        year: _yearController.text,
        frontPressure: int.tryParse(_frontPressureController.text),
        rearPressure: int.tryParse(_rearPressureController.text),
      );

      context.read<AttendanceReportBloc>().add(
            CreateAttendanceReportEvent(
                attendanceReport, signature, attendanceStateImage),
          );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _licensePlateController.clear();
      _mileageController.clear();
      _brand = null;
      _color = null;
      _serviceType = 'Particular';
      _observationsController.clear();

      _nameController.clear();
      _lastnameController.clear();
      _docNumberController.clear();
      _phoneController.clear();
      _addressController.clear();
      _emailController.clear();

      _inviteEvents = true;
      _shareContact = true;
      _sendNews = true;
      _manageRequests = true;
      _conductSurveys = true;
      _reminderRTMyEC = true;
      _isSecondVisit = false;

      _hasAttendanceOwnershipCard = true;
      _hasSoat = true;
      _isTeachingAttendance = false;
      _isAttendanceClean = true;
      _hasCups = false;
      _hasFuel = true;
      _hasTroubleEntering = false;
      _isDischarged = true;
      _isAlarmDeactivated = true;
      _hasCenterSupport = true;
      _hasObstacleToCheckingBrakeFluid = false;
      _obstacleToCheckingBrakeFluid.clear();
      _passengersController.clear();

      _signatureController.clear();
      _motorcycleController.clear();
      _hasShownPreFillSnackbar = false;
    });

    context.pop();
  }

  Future<ui.Image> resizeImage(
    ui.Image image,
    int targetWidth,
    int targetHeight,
  ) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Rect srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final Rect dstRect = Rect.fromLTWH(
      0,
      0,
      targetWidth.toDouble(),
      targetHeight.toDouble(),
    );

    canvas.drawImageRect(image, srcRect, dstRect, Paint());

    return await recorder.endRecording().toImage(targetWidth, targetHeight);
  }

  Widget _buildMotorcycleStateWidget(
    final double screenWidth,
    final double motorcycleImgHeight,
    final double totalWidth,
  ) {
    return RepaintBoundary(
      key: _displayRepaintBoundaryKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                'Estado (Golpe O - Rayón X)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _motorcycleController.clear(),
                icon: const Icon(Icons.clear_rounded),
                tooltip: 'Limpiar estado',
              ),
              IconButton(
                onPressed: _toggleMotorcycleSignatureLock,
                icon: Icon(
                  _isMotorcycleSignatureLocked
                      ? Icons.lock_rounded
                      : Icons.lock_open_rounded,
                  color:
                      _isMotorcycleSignatureLocked ? Colors.red : Colors.green,
                ),
                tooltip: _isMotorcycleSignatureLocked
                    ? 'Desbloquear Interacción'
                    : 'Bloquear Interacción',
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                color: Colors.black12,
                width: totalWidth,
                child: SizedBox(
                  height: motorcycleImgHeight,
                  width: screenWidth,
                  child: Image.asset(
                    'assets/motorcycle_bg3.png',
                    // fit: BoxFit
                    //     .fitHeight, // Cambiado a BoxFit.cover para llenar el espacio
                  ),
                ),
              ),
              AbsorbPointer(
                absorbing: _isMotorcycleSignatureLocked,
                child: Signature(
                  controller: _motorcycleController,
                  height: motorcycleImgHeight,
                  width: screenWidth,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
