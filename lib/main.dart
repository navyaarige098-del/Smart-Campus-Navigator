import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'services/storage_service.dart';
import 'state/campus_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = CampusController(StorageService());
  await controller.load();
  runApp(CampusApp(controller: controller));
}

class CampusApp extends StatelessWidget {
  const CampusApp({super.key, required this.controller});
  final CampusController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => MaterialApp(
        title: 'Smart Campus Navigator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: const Color(0xFF1565C0), useMaterial3: true),
        darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF1565C0), brightness: Brightness.dark, useMaterial3: true),
        themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeShell(controller: controller),
      ),
    );
  }
}
