// This is an example Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
//
// Visit https://flutter.dev/docs/cookbook/testing/widget/introduction for
// more information about Widget testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uxxrapp/src/components/app_textfformfield.dart';
import 'package:uxxrapp/src/components/sys_app_bar.dart';
import 'package:uxxrapp/src/utils/app_colors.dart';
import 'package:uxxrapp/src/utils/strings.dart';

void main() {
  group('Authentication widgets', () {
    testWidgets('test sys app bar widget', (WidgetTester tester) async {
      await tester.pumpWidget(
          const SysAppBar(title: Strings.appTitle, showBackArrow: false));
      final titleFinder = find.text(Strings.appTitle);
      final iconButtonFinder = find.byType(IconButton);

      expect(titleFinder, findsOneWidget);
      expect(iconButtonFinder, findsOneWidget);
    });

    testWidgets("test app textformfield", (WidgetTester tester) async {
      await tester.pumpWidget(
          const AppTextFormField(borderColor: AppColors.greyBorder));
      await tester.enterText(
          find.byType(TextFormField), "test-email@gmail.com");
    });
  });
}
