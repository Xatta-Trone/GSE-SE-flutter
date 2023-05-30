import 'package:go_router/go_router.dart';
import 'package:grese/features/folders/model/folder_response_model.dart';
import 'package:grese/main.dart';
import 'package:grese/screens/crate_folder/create_folder_screen.dart';
import 'package:grese/screens/create_set/create_set_screen.dart';
import 'package:grese/screens/dashboard_screen.dart';
import 'package:grese/screens/folder_detail/folder_detail_screen.dart';
import 'package:grese/screens/import-form-url/import_from_url_screen.dart';
import 'package:grese/screens/saved_folders/saved_folders_screen.dart';
import 'package:grese/screens/saved_lists/saved_lists_screen.dart';

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
    ),
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
    GoRoute(
      name: savedListsScreenKey,
      path: "/saved-lists",
      builder: (context, state) => const SavedListsScreen(),
    ),
    GoRoute(
      name: savedFoldersScreenKey,
      path: "/saved-folders",
      builder: (context, state) => const SavedFoldersScreen(),
    ),
    GoRoute(
      name: folderDetailScreenKey,
      path: "/folder-detail/:folder_id",
      builder: (context, state) {
        var folderIdHere = state.pathParameters['folder_id'];

        return FolderDetailsScreen(
          folderId: folderIdHere,
        );
      },
    ),
  ],
);
