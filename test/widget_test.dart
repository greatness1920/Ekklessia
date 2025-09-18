import 'package:ekklessia/app_state.dart' show AppState;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ekklessia/main.dart';
import 'package:ekklessia/widgets/app_state.dart';

void main() {
  // Helper to build the app with a test AppState
  MyApp createTestApp() {
    final appState = AppState(); // no init() needed for tests
    return MyApp(appState: appState);
  }

  testWidgets('App loads with Home screen and bottom navigation',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp());

        expect(find.text('Home'), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });

  testWidgets('Navigate to Events screen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();

    expect(find.text('Events'), findsWidgets);
  });

  testWidgets('Navigate to Media screen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text('Media'));
    await tester.pumpAndSettle();

    expect(find.text('Media'), findsWidgets);
  });

  testWidgets('Navigate to Giving screen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    await tester.tap(find.text('Giving'));
    await tester.pumpAndSettle();

    expect(find.text('Giving'), findsWidgets);
  });

  testWidgets('Navigate to More screen and check Admin link',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp());

        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();

        expect(find.text('More'), findsWidgets);
        expect(find.text('Admin'), findsOneWidget);
      });

  testWidgets('Navigate to Admin screen from More screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestApp());

        // Open More tab
        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();

        // Tap on Admin link
        await tester.tap(find.text('Admin'));
        await tester.pumpAndSettle();

        // Verify Admin screen opened
        expect(find.text('Admin'), findsWidgets);
      });
}
