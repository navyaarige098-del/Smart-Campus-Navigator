import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_campus_navigator/main.dart';
import 'package:smart_campus_navigator/services/storage_service.dart';
import 'package:smart_campus_navigator/state/campus_controller.dart';

void main() {
  testWidgets('home screen shows title and categories', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(CampusApp(controller: CampusController(StorageService())));
    expect(find.textContaining('Smart Campus'), findsOneWidget);
    expect(find.text('Labs'), findsOneWidget);
    expect(find.text('Get Directions'), findsOneWidget);
  });
}
