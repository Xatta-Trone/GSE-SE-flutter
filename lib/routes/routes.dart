import 'package:go_router/go_router.dart';
import 'package:grese/main.dart';
import 'package:grese/screens/crate_folder/create_folder_screen.dart';
import 'package:grese/screens/create_set/create_set_screen.dart';
import 'package:grese/screens/dashboard_screen.dart';
import 'package:grese/screens/import-form-url/import_from_url_screen.dart';

import 'route_const.dart';

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: homePageScreenKey,
      path: "/",
      builder: (context, state) => const DeciderScreen(),
    ),
    GoRoute(
      name: dashBoardScreenKey,
      path: "/dashboard",
      builder: (context, state) => const DashBoardScreen(),
    )
    ,
    GoRoute(
      name: createSetScreenKey,
      path: "/create-set",
      builder: (context, state) => const CreateSetScreen(),
    ),
    GoRoute(
      name: createFolderScreenKey,
      path: "/create-folder",
      builder: (context, state) => const CreateFolderScreen(),
    ),
    GoRoute(
      name: importURLScreenKey,
      path: "/import-url",
      builder: (context, state) => const ImportFromUrlScreen(),
    ),
  ],
);
