// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_sudoku/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home page shows title and difficulty buttons',
      (WidgetTester tester) async {
    // 設置 SharedPreferences 模擬數據
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(prefs: prefs));

    // 檢查標題
    expect(find.text('數獨'), findsOneWidget);

    // 檢查難度按鈕
    expect(find.text('EASY'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('HARD'), findsOneWidget);

    // 檢查每日挑戰按鈕
    expect(find.text('每日挑戰'), findsOneWidget);
  });
}
