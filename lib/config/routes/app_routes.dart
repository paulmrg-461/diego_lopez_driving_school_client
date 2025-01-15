import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.uri.toString() == '/login';

    if (user == null && !loggingIn) {
      return '/login';
    }
    if (user != null && loggingIn) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/attendance-register',
      name: AttendanceRegisterFormScreen.name,
      builder: (context, state) =>
          AttendanceRegisterFormScreen(userEmail: state.extra as String),
    ),
    GoRoute(
      path: '/operator-register',
      name: OperatorRegisterForm.name,
      builder: (context, state) => const OperatorRegisterForm(),
    ),
    GoRoute(
      path: '/developer-information',
      name: DeveloperInformationScreen.name,
      builder: (context, state) => const DeveloperInformationScreen(),
    ),
    GoRoute(
      path: '/attendance-report-detail',
      name: AttendanceReportDetail.name,
      builder: (context, state) {
        final AttendanceReport report = state.extra as AttendanceReport;

        return AttendanceReportDetail(
          report: report,
        );
      },
    ),
  ],
);
