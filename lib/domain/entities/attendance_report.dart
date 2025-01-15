class AttendanceReport {
  final String licensePlate;
  final int mileage;
  final String brand;
  final String color;
  final String serviceType;
  final String observations;
  final String name;
  final String lastname;
  final String phone;
  final String? documentType;
  final String? documentNumber;
  final String email;
  final String address;
  final DateTime createdAt;
  final bool inviteEvents;
  final bool shareContact;
  final bool sendNews;
  final bool manageRequests;
  final bool conductSurveys;
  final bool reminderRTMyEC;
  final String? signatureUrl;
  final String? attendanceStateImageUrl;
  final String? year;
  final bool? isSecondVisit;
  final int? frontPressure;
  final int? rearPressure;
  final String? operatorUsername;
  final String? engineerUsername;
  final bool? hasAttendanceOwnershipCard;
  final bool? hasSoat;
  final bool? isTeachingAttendance;
  final bool? isAttendanceClean;
  final bool? hasCups;
  final bool? hasTroubleEntering;
  final bool? hasFuel;
  final bool? isDischarged;
  final bool? isAlarmDeactivated;
  final bool? hasCenterSupport;
  final String? obstacleToCheckingBrakeFluid;
  final int? passengersQuantity;

  AttendanceReport({
    required this.licensePlate,
    required this.mileage,
    required this.brand,
    required this.color,
    required this.serviceType,
    required this.observations,
    required this.name,
    required this.lastname,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.inviteEvents,
    required this.shareContact,
    required this.sendNews,
    required this.manageRequests,
    required this.conductSurveys,
    required this.reminderRTMyEC,
    required this.signatureUrl,
    required this.attendanceStateImageUrl,
    required this.year,
    required this.isSecondVisit,
    required this.frontPressure,
    required this.rearPressure,
    required this.operatorUsername,
    required this.engineerUsername,
    required this.hasAttendanceOwnershipCard,
    required this.hasSoat,
    required this.isTeachingAttendance,
    required this.isAttendanceClean,
    required this.hasCups,
    required this.hasTroubleEntering,
    required this.hasFuel,
    required this.isDischarged,
    required this.isAlarmDeactivated,
    required this.hasCenterSupport,
    required this.obstacleToCheckingBrakeFluid,
    required this.passengersQuantity,
  });
}
