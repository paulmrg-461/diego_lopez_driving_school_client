import 'package:diego_lopez_driving_school_client/config/routes/app_routes.dart';
import 'package:diego_lopez_driving_school_client/config/themes/custom_theme.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/operator_bloc/operator_bloc.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/attendance_report/attendance_report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diego_lopez_driving_school_client/core/firebase/firebase_options.dart';
import 'package:diego_lopez_driving_school_client/core/service_locator.dart';
import 'package:diego_lopez_driving_school_client/presentation/blocs/user_bloc/auth_bloc.dart';
import 'core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AuthCheckUserEvent()),
        ),
        BlocProvider(create: (context) => sl<AttendanceReportBloc>()),
        BlocProvider(create: (context) => sl<OperatorBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Diego López App',
        theme: CustomTheme.theme,
      ),
    );
  }
}
