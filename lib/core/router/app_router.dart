import 'package:driver_app/features/drive/presentation/screens/camera_action_screen.dart';
import 'package:driver_app/features/drive/presentation/screens/home_screen.dart';
import 'package:driver_app/features/drive/presentation/screens/job_detail_screen.dart';
import 'package:driver_app/features/drive/presentation/screens/photo_preview_screen.dart';
import 'package:driver_app/features/drive/presentation/screens/stop_action_screen.dart';
import 'package:driver_app/shared/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const jobDetail = '/job/:id';
  static const stopAction = '/stop';
  static const cameraAction = '/camera';
  static const photoPreview = '/photo';

  static String jobWithId(String id) => '/job/$id';
}

final appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: Routes.jobDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return JobDetailScreen(id: id);
      },
    ),
    GoRoute(
      path: Routes.stopAction,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return StopActionScreen(
          jobId: extra['jobId'], 
          stop: extra['stop'],
        );
      },
    ),
    GoRoute(
      path: Routes.cameraAction,
      builder: (context, state) => CameraActionScreen(),
    ),
    GoRoute(
      path: Routes.photoPreview,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PhotoPreviewScreen(mediaPath: extra['mediaPath']);
      },
    ),
  ]
);