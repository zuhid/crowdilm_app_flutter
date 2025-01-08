import 'package:crowdilm/api/quran_api.dart';
import 'package:crowdilm/db/crowdilm_database.dart';
import 'package:crowdilm/pages/quran_page.dart';
import 'package:crowdilm/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'controllers/crowdilm_controller.dart';

var database = CrowdilmDatabase();
var quranApi = QuranApi();
var crowdilmController = CrowdilmController(database, quranApi);
Future main() async {
  await database.open();
  await crowdilmController.getQurans();
  await crowdilmController.getLines();
  await crowdilmController.getSuras();
  await crowdilmController.getQuranLines('en.sahih');
  await crowdilmController.getQuranLines('simple-clean');
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const QuranPage(),
      routes: <RouteBase>[
        GoRoute(path: 'quran', builder: (context, state) => const QuranPage()),
        GoRoute(
            path: 'setting', builder: (context, state) => const SettingPage())
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
