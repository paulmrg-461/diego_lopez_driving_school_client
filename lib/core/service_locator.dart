import 'package:diego_lopez_driving_school_client/data/datasources/firebase_storage_data_source.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_report_by_license_plate.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_reports_by_owner_id.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/operator_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/repositories/operator_repository_impl.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/operator_repository.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/operators/operator_use_cases.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/get_attendance_reports.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/operator_bloc/operator_bloc.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/auth_storage.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/attendance_report_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/repositories/attendance_report_repository_impl.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/attendance_reports/create_attendance_report.dart';
import 'package:diego_lopez_driving_school_client/data/datasources/firebase_auth_data_source.dart';
import 'package:diego_lopez_driving_school_client/data/repositories/auth_repository_impl.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/auth_repository.dart';
import 'package:diego_lopez_driving_school_client/domain/usecases/authentication/authentication_use_cases.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/user_bloc/auth_bloc.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/attendance_report/attendance_report_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Registros de Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FirebaseStorageDataSource>(
    () => FirebaseStorageDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AttendanceReportDataSource>(
    () => AttendanceReportDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OperatorDataSource>(
    () => OperatorDataSourceImpl(sl<FirebaseFirestore>()),
  );

  // Repositorios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AttendanceReportRepository>(
    () => AttendanceReportRepositoryImpl(
      dataSource: sl<AttendanceReportDataSource>(),
      storageDataSource: sl<FirebaseStorageDataSource>(),
    ),
  );
  sl.registerLazySingleton<OperatorRepository>(
    () => OperatorRepositoryImpl(
      dataSource: sl<OperatorDataSource>(),
      storageDataSource: sl<FirebaseStorageDataSource>(),
    ),
  );

  // Casos de Uso
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => CreateAttendanceReport(sl()));
  sl.registerLazySingleton(() => GetAttendanceReportsByDateRange(sl()));
  sl.registerLazySingleton(() => GetAttendanceReportByLicensePlate(sl()));
  sl.registerLazySingleton(() => GetAttendanceReportsByOwnerId(sl()));
  sl.registerLazySingleton(
    () => CreateOperator(
      repository: sl<OperatorRepository>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerLazySingleton(() => GetOperators(sl<OperatorRepository>()));
  sl.registerLazySingleton(() => UpdateOperator(sl<OperatorRepository>()));
  sl.registerLazySingleton(() => DeleteOperator(sl<OperatorRepository>()));
  sl.registerLazySingleton(() => UploadFile(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authStorage: sl(),
    ),
  );

  sl.registerFactory(
    () => AttendanceReportBloc(
      createAttendanceReportUseCase: sl<CreateAttendanceReport>(),
      getAttendanceReportsByDateRange: sl<GetAttendanceReportsByDateRange>(),
      getAttendanceReportByLicensePlate:
          sl<GetAttendanceReportByLicensePlate>(),
      getAttendanceReportsByOwnerId: sl<GetAttendanceReportsByOwnerId>(),
    ),
  );

  sl.registerFactory(
    () => OperatorBloc(
      createOperatorUseCase: sl<CreateOperator>(),
      getOperatorsUseCase: sl<GetOperators>(),
      updateOperatorUseCase: sl<UpdateOperator>(),
      deleteOperatorUseCase: sl<DeleteOperator>(),
      uploadFileUseCase: sl<UploadFile>(),
    ),
  );

  // Data storage
  sl.registerLazySingleton<AuthStorage>(() => AuthStorage());
}
