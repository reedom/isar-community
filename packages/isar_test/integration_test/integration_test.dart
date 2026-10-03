// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar_test/isar_test.dart';
import 'package:path_provider/path_provider.dart';

import 'all_tests.dart' as tests;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final completer = Completer<void>();

  group('Integration test', () {
    setUpAll(() async {
      if (!kIsWeb) {
        final dir = await getTemporaryDirectory();
        // path_provider_foundation 2.6+ returns the Caches path without
        // creating it, and Isar cannot open a missing directory.
        await dir.create(recursive: true);
        testTempPath = dir.path;
      }
    });
    tearDownAll(() {
      print('Isar test done');
      completer.complete();
    });

    tests.main();
  });

  testWidgets(
    'Isar',
    (t) async {
      await completer.future;
      expect(testCount > 0, true);
      expect(testErrors, isEmpty);
    },
    timeout: Timeout.none,
  );
}
